kmod DIJKSTRA is including NAT-INF + #ID
  configuration <graph> .Set </graph> <shortest> .Map </shortest>

  syntax Edge ::= Id - Nat -> Id [latex "{#1}\xrightarrow{{#2}}{#3}"]

  syntax K ::= Id 
  syntax SetItem ::= Edge
  
  rule <graph_> x1 -w:Nat-> x2 <_/graph> 
       <shortest_> 
          x1:Id |-> c1:Nat  x2:Id |-> (c2:NatInf => c1 +Nat w) 
       <_/shortest>
    if w +Nat c1 <Nat c2
endkm
