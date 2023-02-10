/****************CREATION DE LA TABLE DES SYMBOLES ******************/
/***Step 1: Definition des structures de données ***/
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
typedef struct ts_tdf
{
   int state;
   char name[20];
   char code[20];
   char type[20];
   float val;
   struct ts_tdf *suiv;
 } idf; //data type : struct ts_idf == idf 

typedef struct ts_mcs
{ 
   int state; 
   char name[20];
   char type[20];   
   struct ts_mcs *suiv;
} mc,sep,both;

typedef struct pointeur {
	idf *pidf;
	mc *pmc;
	sep *psep;
}pointer_type;


/***Step 2: creation des listes des symbloles***/
// liste des idf
idf* creationCellule_idf(idf *t){
	 t=(idf*)malloc(sizeof(idf));							 
	 (t)->suiv=NULL;
	return t;
};
// liste des mc
mc* creationCellule_mc(mc *t){
	 t=(mc*)malloc(sizeof(mc));
	 (t)->suiv=NULL;
	 return t;
};
//liste des  sep
sep* creationCellule_sep(sep *t){
	 t=(sep*)malloc(sizeof(sep));
	 (t)->suiv=NULL;
	 return t;
};

/***Step 4: insertion des entititées lexicales dans les tables des symboles ***/

pointer_type inserer (char entite[], char code[],char type[],float val,both *p,idf *t,int y)
{ 	
pointer_type result;
  switch (y)
 { 
   case 0:/*insertion dans la table des IDF et CONST
			mettre state à 1,
			insérer: name, code, type, val*/
		if(t == NULL){
			t = creationCellule_idf(t);
		}
		t->state=1;
        strcpy(t->name,entite);
        strcpy(t->code,code);
	    strcpy(t->type,type);
	    t->val=val;
        result.pidf = t;
	   break;

   case 1:/*insertion dans la table des mots clés
			mettre state à 1, incrémenter cptm;
			insérer: name, code*/

		if(p == NULL){
			p = creationCellule_mc(p);
		}
       p->state=1;
       strcpy(p->name,entite);
       strcpy(p->type,code);
       result.pmc = p;
       break; 
    
   case 2:/*insertion dans la table des séparateurs
			mettre state à 1, incrémenter cpts
			insérer: name, code*/
		if(p == NULL){
			p = creationCellule_sep(p);
		}
      p->state=1;
      strcpy(p->name,entite);
      strcpy(p->type,code);
	  result.psep = p;

      break;
 }
return result;
}


/***Step 3: La fonction Rechercher permet de verifier  si l'entité existe dèja dans la liste des symboles */
pointer_type rechercher (char entite[], char code[],char type[],float val,int y,idf *t,both *p)	
{
idf *t1,*t2;
both *p1,*p2;
int boo = 1;
p1 = p;
t1 = t;
pointer_type result;
switch(y) 
  {
   case 0:
			/*Chercher si entite existe dans liste idf: si non on appelle la fonction inserer:
			inserer(entite, code, type, val, y);*/
		if(t!=NULL){
		t2 = t->suiv;
			    while(t1!=NULL){
				   if(strcmp(entite,t1->name)==0) { 
						boo = 0;
						t1 = NULL;
				   }
				   else {
					   if(t2==NULL) {t1->suiv = inserer(entite,code,type,val,NULL,t2,0).pidf;boo = 0;t1=NULL;}
						else {t2=t2->suiv;t1=t1->suiv;}
						
				   }
			    }       
		}else{
		t = inserer(entite,code,type,val,NULL,t,0).pidf;
		}
		result.pidf = t;
        break;
   case 1:
       /*Chercher si entite existe dans tabm: si non on appelle la fonction inserer*/
	   if(p!=NULL){
		p2 = p->suiv;					
				while(p1!=NULL){	
				   if(strcmp(entite,p1->name)==0) { 
						boo = 0;
						p1 = NULL;
				   }
				   else {
					   if(p2==NULL) {p1->suiv = inserer(entite,code,type,val,p2,NULL,1).pmc; boo = 0; p1=NULL;}
					     else {p2=p2->suiv;p1=p1->suiv;}		
				   }
				}      
		}else{
			p = inserer(entite,code,type,val,p,NULL,1).pmc;
		}       	
	result.pmc = p;
        break; 
   case 2:
			//printf("Rechercher séparateur\n");
         /*Chercher si entite existe dans tabs: si non on appelle la fonction inserer*/
		if(p!=NULL){//si la liste n'est pas encore cree p = null 
		p2 = p->suiv;
			   while(p1!=NULL){
				   if(strcmp(entite,p1->name)==0){ 
						boo = 0;
						p1 = NULL;
				   }
				   else {//la liste contient un seul champ
					   if(p2==NULL) {p1->suiv = inserer(entite,code,type,val,p2,NULL,2).psep; boo = 0;p1=NULL;}
							else {p2=p2->suiv;p1=p1->suiv;}
				   }
			    }      
		}else{
			p = inserer(entite,code,type,val,p,NULL,2).psep;
		}
	    result.psep = p;
        break;
  }
return result;
}


/***Step 5 L'affichage du contenue de la table des symboles ***/

void afficher(mc *p,sep *y,idf *t)
{
	idf *t1;
	both *t2;
	t1=t;
	t2=p;


	printf("\n/***************Table des symboles IDF*************/\n");
	printf("____________________________________________________________________\n");
	printf("\t| Nom_Entite |  Code_Entite | Type_Entite | Val_Entite\n");
	printf("____________________________________________________________________\n");

	while(t1 != NULL){	//idf

		if(t1->state==1)
		  { 	
			printf("\t|%10s |%15s | %12s | %12f\n",t1->name,t1->code,t1->type,t1->val);
			 
		  }
		t1=t1->suiv;
	}
	free(t1);

	printf("\n/***************Table des symboles mots cles*************/\n");

	printf("_____________________________________\n");
	printf("\t| NomEntite |  CodeEntite | \n");
	printf("_____________________________________\n");

	while(t2 != NULL){	//mc
		if(t2->state==1)
		  { 
			printf("\t|%10s |%12s | \n",t2->name, t2->type);
				   
		  }
		t2=t2->suiv;
	}

	printf("\n/***************Table des symboles separateurs*************/\n");

	printf("_____________________________________\n");
	printf("\t| NomEntite |  CodeEntite    | \n");
	printf("_____________________________________\n");
	
	t2=y;
	while(t2 != NULL){ //sep
		if(t2->state==1)
		  { 
			printf("\t|%10s |%15s | \n",t2->name,t2->type );
			
		  }
		  t2=t2->suiv;
	}
	free(t2);
}



/*** Partie Semantique ***/
int recherche(char entite[],idf *t)
{
	idf *t1;
	t1=t;
   int i=0;
   while(t1 != NULL){
	if(strcmp(entite,t1->name)==0) return i;
	i++;
	t1=t1->suiv;
   }
   return -1;
}

void insererValeur(char entite[],idf *t,char *vale)
{ 
	idf *t1;
	t1=t;
	int pos,y=0;
    float valeur;
	valeur=atof(vale);
	pos=recherche(entite,t1);
	while(y<pos)
	{
       t1=t1->suiv;
	   y++;
	}
	if(t1 != NULL) t1->val=valeur;

}

void insererTYPE(char entite[], char type[],idf *t)
{
	idf *t1;
	t1=t;
	int pos,y=0;
	pos=recherche(entite,t1);
	while(y<pos)
	{
       t1=t1->suiv;
	   y++;
	}
	if(t1 != NULL) strcpy(t1->type,type);
}

int doubleDeclaration(char entite[],idf *t)
{
	idf *t1;
	t1=t;
	int pos,y=0;
	pos=recherche(entite,t1);
	while(y<pos)
	{
       t1=t1->suiv;
	   y++;
	}
	if(strcmp(t1->type,"")==0)
		return 0;
	else 
		return -1;
}

int gettype(char entite[],idf *t)
{
	idf *t1;
	t1=t;
	int pos,y=0;
	pos=recherche(entite,t1);
	while(y<pos)
	{
       t1=t1->suiv;
	   y++;
	}
	if(t1 != NULL)
    {
		if(strcmp("int",t1->type)==0){ 
			return 0;
		}else {
			if(strcmp("float",t1->type)==0){
				return 2;
			}else 
				return 1;
		}
	}
}
float getval(char entite[],idf *t)
{
	idf *t1;
	t1=t;
	int pos,y=0;
	float val;
	pos=recherche(entite,t1);
	while(y<pos)
	{
       t1=t1->suiv;
	   y++;
	}
	if(t1 != NULL)
    {
		val=t1->val;
	}
	return val;
}

int compatibletype(int type1,int type2)
{
	printf("--------- %d %d",type1,type2);
	switch(type1){		
	case 0:
		if(type2!=0) return -1;else return 0;//int
	break;
	case 2:
		if(type2==2 || type2==0) return 0;else return -1;//float
	break;
	case 1:
		if(type2!=1) return -1;else return 0;//char
	break;	
	}
}

int typedeclaration(int type1,int type2)
{
	if(type1 != type2){
		return 0;}
	else{
		return 1;}
}
