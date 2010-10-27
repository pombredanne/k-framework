#include <stdlib.h>

struct treeNode {
  int val;
  struct treeNode *left;
  struct treeNode *right;
};

struct nodeList {
  int val;
  struct nodeList *next;
};

struct treeNodeList {
  struct treeNode *val;
  struct treeNodeList *next;
};


struct nodeList *toListIterative(struct treeNode *root)
/*@ pre < config > < env > root |-> ?root </ env >
                   < heap > tree(?root)(Tree) heapFrame </ heap >
                   < form > TrueFormula </ form > </ config > */
/*@ post < config > < env > ?rho </ env >
                    < heap > list(?a)(tree2seq(Tree)) heapFrame </ heap >
                    < form > returns ?a </ form > </ config > */
{
  struct nodeList *a;
  struct nodeList *node;
  struct treeNode *t;
  struct treeNodeList *stack;
  struct treeNodeList *x;

  if (root == 0)
    return 0;
  a = 0;
  stack = (struct treeNodeList *) malloc(sizeof(struct treeNodeList));
  stack->val = root;
  stack->next = 0;
  /*@ invariant
        < config >
          < env >
            root |-> ?root a |-> ?a stack |-> ?stack
            t |-> ?t x |-> ?x node |-> ?node
          </ env >
          < heap > list{tree}(?stack)(?TS) list(?a)(?A) heapFrame </ heap >
          < form > tree2seq(Tree) === seq{tree}2seq(rev(?TS)) @ ?A </ form >
        </ config > */
  while (stack != 0) {
    x = stack;
    stack = stack->next ;
    t = x->val;
    free(x) ;
    if (t->left != 0) {
      x = (struct treeNodeList *) malloc(sizeof(struct treeNodeList));
      x->val = t->left;
      x->next = stack;
      stack = x;
    }
    if (t->right != 0) {
      x = (struct treeNodeList *) malloc(sizeof(struct treeNodeList));
      x->val = t;
      x->next = stack;
      stack = x;
      x = (struct treeNodeList *) malloc(sizeof(struct treeNodeList));
      x->val = t->right;
      x->next = stack;
      stack = x;
      t->left = t->right = 0;
    }
    else {
      node = (struct nodeList *) malloc(sizeof(struct nodeList));
      node->val = t->val;
      node->next = a;
      a = node;
      free(t);
    }
  }
  return a;
}


/*@ var ?root ?a ?stack ?t ?x ?node : ?Int */
/*@ var ?rho : ?MapItem */
/*@ var heapFrame : FreeMapItem */
/*@ var Tree : FreeTree */
/*@ var ?TS ?A : ?Seq */
