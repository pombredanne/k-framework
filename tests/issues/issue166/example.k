
kmod ASSOC is
	including K + #BOOL + #INT + #ID
	
	syntax Exp ::= Id | Val | Exp + Exp
	syntax Val ::= Int | Bool
        syntax KResult ::= Val
        syntax K ::= Exp
        syntax ValSet ::= .ValSet
	syntax ValSet ::=  Val
                        | ValSet ValSet [hybrid gather(E e) comm id: .ValSet]
endkm
