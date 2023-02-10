
typedef struct quad{

    char oper[100]; 
    char op1[100];   
    char op2[100];   
    char res[100]; 
	int position;
	struct quad *suiv;
    
  }quad;
quad *qc,*deb_else,*Fin_if,*p,*Fin_for1,*Fin_for2,*debut_for,*Fin_while,*deb1,*deb2,*BR;

int pos = -1;
quad *creation(quad *q){
	q = malloc(sizeof(quad));
	q->suiv=NULL;
	return q;
}
quad* quadr(char opr[],char op1[],char op2[],char res[])
{
pos ++;
	if(p == NULL){
		p = creation(p);
		qc = p;// p pointeur de liste
			//qc c la position
	}
	else {
		qc->suiv = creation(qc->suiv);
		qc = qc->suiv;
		}
	strcpy(qc->oper,opr);
	strcpy(qc->op1,op1);
	strcpy(qc->op2,op2);
	strcpy(qc->res,res);
	qc->position = pos;


return qc;//on garde le p sur la tete de liste pour ne pas la perdre, on cree les quad avec le qc
}

void ajour_quad(quad *num_quad, int colon_quad, char val [])
{
quad *a;
a = p;
if (colon_quad==0) { while(a->position!=num_quad->position){a=a->suiv;};strcpy(a->oper,val); }
else if (colon_quad==1) {while(a->position!=num_quad->position){a=a->suiv;};strcpy(a->op1,val); }
         else if (colon_quad==2) { while(a->position!=num_quad->position){a=a->suiv;};strcpy(a->op2,val); }
                   else if (colon_quad==3) { while(a->position!=num_quad->position){a=a->suiv;}strcpy(a->res,val); }

}

void afficher_qdr()
{
printf("*********************Les Quadruplets***********************\n");

quad *a;
a = p;
int i = 0; 
while(a!=NULL){

 printf("\n %d - ( %s  ,  %s  ,  %s  ,  %s )",i,a->oper,a->op1,a->op2,a->res); 
 printf("\n--------------------------------------------------------\n");

 i++;
 a = a->suiv;
}
  printf("\n %d - ( vide , vide , vide , vide )\n",i); 
  printf("\n--------------------------------------------------------\n");

}
