#include <stdlib.h>
#include <stdio.h>

struct nodeList {
  int val;
  struct nodeList *next;
};

struct nodeList* clenque(struct nodeList* x, int val)
/*@ pre  < config > < env > x |-> x0 val |-> val0 </ env >
                    < heap > x0 |-> v0 : (nodeList . val)
                            (x0 +Int 1) |-> t0 : (nodeList . next)
                             lseg(t0,x0)(A)
                    H </ heap >
                    < form > TrueFormula </ form > C </ config > */
/*@ post < config > < env >  ?rho </ env >
                    < heap > ?x |-> val0 : (nodeList . val)
                            (?x +Int 1) |-> t0 : (nodeList . next)
                            lseg(t0,?x)(A @ [v0])
                    H </ heap > 
                    < form > returns ?x </ form > C </ config > */
{
  struct nodeList* aux;
  aux = (struct nodeList*)malloc(sizeof(struct nodeList));
  aux->val = val;
  aux->next = x->next;
  x->next = aux;
  x = x->next;
  return x;
}

/*@ verify */
int main()
{
  struct nodeList *x;
  struct nodeList *y;
  x = (struct nodeList*)malloc(sizeof(struct nodeList));
  x->val = 5;
  x->next = 0;
  y = (struct nodeList*)malloc(sizeof(struct nodeList));
  y->val = 8;
  y->next = x;
  x->next = y;
  printf("%d %d\n", x->val, y->val);
  x = clenque(x,9);
  printf("%d %d %d\n", x->val, x->next->val, x->next->next->val);
  return 0;
}

/*@ var x0 v0 val0 t0 : FreeInt */
/*@ var ?x ?aux : ?Int */
/*@ var A : FreeSeq */
/*@ var ?rho ?H : ?MapItem */
/*@ var H : FreeMapItem */
/*@ var C : FreeBagItem */


