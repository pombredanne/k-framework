{-
  Parse the config file given, building up the desired Configuration
  Config files are yaml documents of the form:
    <cellname>: [y(es)|n(o)]
    ...
  to configure whether to display that cell.
  See examples/example.yml
  If a cell is flagged as "yes", then it will be shown (this has no effect on its children)
  Current default behavior is to not show anything not explicitly told to be shown
-}

module ParseConfig where
  import Data.Yaml.Syck
  import Control.Applicative
  import Data.Char
  import Control.Arrow
  import Data.List

  type CellName = String
  type Configuration = [CellConfig]

  type CellConfig = (String, CellConfigRhs)

  -- add more to this to support more customizations
  data CellConfigRhs = Show
                     | Hide
                     | RecursiveHide
                     | Configs { keepLines :: Maybe Int
                               , cellStyle :: Maybe Style
                               , textStyle :: Maybe Style
                               }
    deriving (Show)

  data Style = Style { foreground :: Maybe Color
                     , background :: Maybe Color
                     , underlined :: Maybe Underline
                     , bold       :: Maybe Bold
                     }
    deriving Show

  data Underline = Underline | DeUnderline
    deriving Show

  data Bold = Bold | DeBold
    deriving Show

  data Color = Black | Red | Green | Yellow | Blue | Magenta | Cyan | White
             | Dullblack |Dullred | Dullgreen | Dullyellow | Dullblue | Dullmagenta
             | Dullcyan | Dullwhite
    deriving (Show, Read)

  -- A Yaml tree without superfluous info and types
  data YamlLite = Map [(YamlLite, YamlLite)]
                | Seq [YamlLite]
                | Str String
                | Nil
    deriving (Show)


  -- Convert to the lighter representation
  yamlNodeToLite :: YamlNode -> YamlLite
  yamlNodeToLite = yamlElemToLite . n_elem

  yamlElemToLite :: YamlElem -> YamlLite
  yamlElemToLite (EMap ms)  = Map $ map (\(a,b) -> (yamlNodeToLite a, yamlNodeToLite b)) ms
  yamlElemToLite (ESeq s)   = Seq $ map yamlNodeToLite s
  yamlElemToLite (EStr buf) = Str $ unpackBuf buf
  yamlElemToLite (ENil)     = Nil

  parseYamlFileLite fp = yamlNodeToLite <$> parseYamlFile fp


  -- Get the configuration
  extractConfiguration :: YamlLite -> Configuration
  extractConfiguration = (map extractCellConfig . unMap)

  -- I use arrows because I'm awesome. See the commented out version for the more clear version
  extractCellConfig :: (YamlLite, YamlLite) -> CellConfig
  extractCellConfig = arr unStr *** arr readConfig
  -- extractCellConfig (l,r) = (unStr l, readConfig r)


  -- Extend the below function to add more functionality
  readConfig :: YamlLite -> CellConfigRhs
  readConfig (Str s) = readSingleEntry s
  readConfig (Map map) = readMap map

  readMap :: [(YamlLite,YamlLite)] -> CellConfigRhs
  readMap xs = Configs (getLines <$> (lookup doKeep))
                       (getStyle <$> (lookup doCellStyle))
                       (getStyle <$> (lookup doTextStyle))
    where lookup ss   = snd <$> (find ((flip compareStr) ss . unStr . fst) $ xs)
          doKeep      = ["lines", "keep"]
          doCellStyle = ["cell-color", "cell-style"]
          doTextStyle = ["text-color", "text-style"]

  getLines :: YamlLite -> Int
  getLines (Str s) = tryRead areNumbers s $ "Unable to parse: " ++ s ++ " as a number"
  getLines _ = error $ "Internal error: getLines called on non-terminal value"

  getStyle :: YamlLite -> Style
  getStyle (Map map) = Style (getColor     <$> (lookup doForeground))
                             (getColor     <$> (lookup doBackground))
                             (getUnderline <$> (lookup doUnderline))
                             (getBold      <$> (lookup doBold))
    where lookup ss = snd <$> (find ((flip compareStr) ss . unStr . fst) $ map)
          doForeground = ["foreground"]
          doBackground = ["background"]
          doUnderline  = ["underline", "underlined"]
          doBold       = ["bold"]

  getColor :: YamlLite -> Color
  getColor (Str s) = tryRead isColor s $ "Unable to parse: " ++ s ++ " as a color"
  getColor _ = error $ "Internal error: getColor called on non-terminal value"

  getUnderline :: YamlLite -> Underline
  getUnderline (Str s) | s `compareStr` doUnderline   = Underline
                       | s `compareStr` doDeUnderline = DeUnderline
                       | otherwise                    = error $ "Unable to parse: " ++ s ++ " as an underline style"
    where doUnderline   = ["underline", "under-line", "underlined"]
          doDeUnderline = ["deunderline", "de-underline", "de-under-line"]

  getBold :: YamlLite -> Bold
  getBold (Str s) | s `compareStr` doBold   = Bold
                  | s `compareStr` doDeBold = DeBold
                  | otherwise               = error $ "Unable to parse: " ++ s ++ " as an underline style"
    where doBold   = ["bold", "embolden"]
          doDeBold = ["debold", "de-bold", "un-bold", "unbold"]


  getTextStyle yl = []

  isColor :: String -> Bool
  isColor = flip compareStr $ [ "Black", "Red", "Green", "Yellow", "Blue", "Magenta", "Cyan"
                              , "White", "Dullblack", "Dullred", "Dullgreen", "Dullyellow"
                              , "Dullblue", "Dullmagenta", "Dullcyan", "Dullwhite"
                              ]

  readSingleEntry :: String -> CellConfigRhs
  readSingleEntry s | compareStr s doShow    = Show
                    | compareStr s doHide    = Hide
                    | compareStr s doHideRec = RecursiveHide
--                    | compareStr s doShowRec = RecursiveShow
                    | otherwise              = error $ "Unknown value: " ++ s
    where doShow    = doTrue ++ ["show"]
          doHide    = doFalse ++ ["hide"]
          doHideRec = ["hide-recursive", "recursive-hide", "recursively-hide", "hide-recursively"]
          doShowRec = ["show-recursive", "recursive-show", "recursively-show", "show-recursively"]

  doTrue  = ["yes", "y", "t", "true"]
  doFalse = ["no", "n", "f", "false"]


  -- Compare the contents of the config item to see if it occurs in passed strings.
  compareStr :: String -> [String] -> Bool
  compareStr s ss = canonicalize s `elem` map canonicalize ss

  canonicalize = map toLower

  areNumbers :: String -> Bool
  areNumbers = and . map isDigit

  getConfig :: FilePath -> IO Configuration
  getConfig fp = extractConfiguration <$> parseYamlFileLite fp

  -- Data "destructors", not so safe and meant to be expanded with ones raising more useful errors
  -- Todo: implement a more robust solution using generics
  unSeq :: YamlLite -> [YamlLite]
  unSeq (Seq s) = s

  unMap :: YamlLite -> [(YamlLite,YamlLite)]
  unMap (Map m) = m

  unStr :: YamlLite -> String
  unStr (Str s) = s

  -- Read utilities
  tryRead :: Read a => (String -> Bool) -> String -> String -> a
  tryRead p s err = if p s then read s else error err