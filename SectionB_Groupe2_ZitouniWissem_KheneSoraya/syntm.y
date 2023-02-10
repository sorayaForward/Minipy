%{
 extern int yylineo; 
 int col=1; //declaraction du cpt de nombre de colonne
 char souvtype[20];
 char valeur[20];
 extern a;
 extern b;
 extern c; 
  //dec pour quad
 char tmp[20],tmpElse[20],tmpdb[20];
 extern Fin_if,Fin_for1,Fin_for2,debut_for,deb_else,Fin_while,deb1,deb2,BR;
 extern p;//qc = indice qui indique sur quel quadruplet on est
 extern qc;
 extern pos;
 char val[20]; 
 char vall[20]; 
 char valll[20];
 typedef struct dec_tab{
	 char *name;
	 char *size;
	 struct dec_tab* suiv;
 }tab;
 tab *t,*u;
 int first = 1;
 int trv1 = 0;
 int po,cptTemp;
 int typ=-1;

%}

%start S

%token nbrentier nbrreel cstbool IDF <str>mc_entier <str>mc_reel <str>mc_char <str>mc_bool <str>mc_and <str>mc_or <str>mc_not mc_aff mc_if mc_else 
mc_for mc_range mc_in mc_while mc_parouv mc_parfer mc_acouv mc_acfer mc_dpoint mc_plus mc_moins mc_mul mc_div <str>mc_inf mc_inrange
<str>mc_infeq <str>mc_sup <str>mc_supeq <str>mc_dif <str>mc_equal vg sdl tabul cstchar spt gi err sptt
%union {
	int entier; 
	float reel; 
	char *str;
	struct{
	  int type;
	  char *ctx;
	  float v;
    }tt;
}
%type<str> nbrentier nbrreel cstbool IDF
%type<entier> TYPE ELSE
%type<tt> EXPRESSION CST CONDITION 
%type<str> LIST_IDF DEC_TAB

%right mc_aff
%left mc_or
%left mc_and
%left mc_not
%left mc_inf mc_infeq mc_sup mc_supeq mc_equal mc_dif
%left mc_plus mc_moins
%left mc_mul mc_div
%left mc_parouv mc_parfer

%%

S :LIST_DEC LIST_INST
{ printf("Le prgramme est correcte syntaxiquement"); YYACCEPT;}
;
LIST_DEC :DEC LIST_DEC
          | 
;        
DEC :DEC_VAR 
    |DEC_TAB 
;
DEC_VAR : TYPE spt IDF LIST_IDF sdl {
					if(doubleDeclaration($3,a)==0){	
						insererTYPE($3,souvtype,a); 
				       if(typ != -1 ){
                        if(typedeclaration($1,typ)==0){
							printf(">> Err sem : valeur fausse erreur semantique dans la ligne %d\n",yylineo);
							return 0;
						}
						if((typ==0) || (typ==2)){
                        insererValeur($3,a,valeur);
						}
					   }
					   typ =-1;
                     }
                     else{
						printf(">> Err sem : double declaration %s la ligne %d\n", $3,yylineo);
					 }
		}                 
;       
LIST_IDF :vg IDF LIST_IDF {
					if(doubleDeclaration($2,a)==0){
						insererTYPE($2,souvtype,a); 
					}
                    else{
						printf(">> Err sem : double declaration %s la ligne %d\n", $2,yylineo);
					}
		}                     
         |mc_aff CST { 
		         
			    qc = quadr("=",$2.ctx,"vide",$$);
         }
         |{ printf("");}
;

DEC_TAB : TYPE spt IDF mc_acouv nbrentier mc_acfer sdl {
                         if(doubleDeclaration($3,a)==0){
						      printf("entite non declarer\n"); 
							  insererTYPE($3,souvtype,a);
				              qc = quadr("BOUNDS","0",$5,"vide");
							  qc = quadr("ADEC",$3,"vide","vide");
							  if(first){t=(tab*)malloc(sizeof(tab));u=t;first=0;}
							  else {u->suiv=(tab*)malloc(sizeof(tab));u=u->suiv;}
							  u->name=strdup($3);
							  u->size=strdup($5);
							  u->suiv=0;
						 }							  
                           else{
						      printf(">> Err sem : double declaration %s la ligne %d\n", $3,yylineo);}
						 }
;
TYPE : mc_entier{strcpy(souvtype,$1);$$=0;}
     | mc_reel{strcpy(souvtype,$1);$$=2;}
     | mc_char{strcpy(souvtype,$1);$$=1;}
     | mc_bool{strcpy(souvtype,$1); $$=3;}
;

CST :nbrentier {strcpy(valeur,$1);typ=0; $$.type =0; $$.ctx=strdup($1);}
    |nbrreel {strcpy(valeur,$1); typ=2;$$.type =2; $$.v=atof($1);$$.ctx=strdup($1);}
    |cstbool {$$.type =3;typ=3;$$.ctx=strdup($1);}
    |cstchar {$$.type =1;typ=1;$$.ctx=strdup($1);}
;  

LIST_INST : INST LIST_INST
            | 
;
INST : INST_AFF
      |INST_IF
      |INST_FORA
      |INST_FORB
      |INST_WHILE; 
INST_AFF :IDF mc_aff EXPRESSION sdl  { 
			if(doubleDeclaration($1,a)==0) {
				printf(">> Err sem : entite non declarer dans la ligne %d ,erreur semantique\n",yylineo); return 0; 
			}else{
				int t;
				t= gettype($1,a);
				if(compatibletype(t,$3.type)!=0)
				{
				  printf(">> Err sem : Incompatibilite des types dans la ligne %d et la colonne %d\n",yylineo,col);
				  return 0;
				}else{ 
				  qc = quadr("=",$3.ctx,"vide",$1);
				}
			}
		}
        |IDF mc_acouv nbrentier mc_acfer mc_aff EXPRESSION sdl { 
			if(doubleDeclaration($1,a)==0){
                 printf(">> Err sem : variable non declaré dans la ligne %d et la colonne %d\n",yylineo,col); return 0;
            }else{
                 int t = gettype($1,a);
                 if(compatibletype(t,$6.type)!=0){
                   printf(">> Err sem : Incompatibilite des types dans la ligne %d \n",yylineo);
                   return 0;
                 }else{
				 strcat(val,$1);
				 strcat(val,"[");
				 strcat(val,$3);
				 strcat(val,"]");
				 qc = quadr("=",$6.ctx,"vide",val);
				 }
            }
		 }

;
EXPRESSION : EXPRESSION mc_plus EXPRESSION {if($1.type==2 || $3.type==2)
                                              {$$.type=2;}
                                            else  $$.type=0;
                                                  $1.ctx=strdup($$.ctx);
												  strcpy(val,"");
												  strcat(val,"temp ");
												  sprintf(vall,"%d",cptTemp);
												  strcat(val,vall);
												  strcpy($$.ctx,val);
										   qc = quadr("+",$1.ctx,$3.ctx,$$.ctx);
										   cptTemp++;
                                          }
            |EXPRESSION mc_moins EXPRESSION {
			                              if($1.type==2 || $3.type==2)
                                          {$$.type=2;}
                                          else $$.type=0;
                                          $1.ctx=strdup($$.ctx);
										  strcpy(val,"");
										  strcat(val,"temp ");
												  sprintf(vall,"%d",cptTemp);
												  strcat(val,vall);
												  strcpy($$.ctx,val);
										   qc = quadr("-",$1.ctx,$3.ctx,$$.ctx);
										   cptTemp++;
                                          }
            |EXPRESSION mc_mul EXPRESSION {if($1.type==2 || $3.type==2)
                                          {$$.type=2;}
                                          else $$.type=0;
                                          $1.ctx=strdup($$.ctx);
										  strcpy(val,"");
										  strcat(val,"temp ");
												  sprintf(vall,"%d",cptTemp);
												  strcat(val,vall);
												  strcpy($$.ctx,val);
										  qc = quadr("*",$1.ctx,$3.ctx,$$.ctx);
									   	  cptTemp++;
                                          }
            |EXPRESSION mc_div EXPRESSION {if($3.v==0){printf("division par 0 erreur semantique\n"); return 0;
                                         }else{
			                            {if($1.type==2 || $3.type==2)
                                          {$$.type=2;}
                                          else $$.type=0;
                                          $1.ctx=strdup($$.ctx);
										  strcpy(val,"");
										  strcat(val,"temp ");
												  sprintf(vall,"%d",cptTemp);
												  strcat(val,vall);
												  strcpy($$.ctx,val);
										  qc = quadr("/",$1.ctx,$3.ctx,$$.ctx);
                                          cptTemp++;										  
                                          }
										 }}
            |IDF {
                    if(doubleDeclaration($1,a)==0)
                    {
                      printf(">> Err sem : variable non declarer la ligne %d et la colonne %d\n",yylineo,col); return 0;
                    }
                    else
                    {  
                        int k =gettype($1,a);
                        if(k!=2) 
                        k=0;
                        $$.ctx=$1;
                        $$.type=k;
                        $$.v=getval($1,a);  
                    }
                 }
            |CST {		
 
			   if($1.type ==0 || $1.type ==2)
               {
			     int k=$1.type;         
                 $1.ctx=strdup($$.ctx);
                 $$.type=k;
			   }
             }
            |mc_parouv EXPRESSION mc_parfer 
			{ 
			  if($2.type ==0 || $2.type ==2)
              {
			     int k= $2.type;         
                 $2.ctx=strdup($$.ctx);
                 $$.type=k;
				 $$.v=$2.v;
			  }
            }
			|IDF mc_acouv nbrentier mc_acfer{
			             if(doubleDeclaration($1,a)==0)
							 {
								 printf(">> Err sem : variable non declarer dans la ligne %d et la colonne %d\n",yylineo,col); return 0;
							 }
						 else
							 {
								 int k = gettype($1,a);
								 if(k!=2) k=0;
								 strcpy(val,"");
								 strcat(val,$1);
								 strcat(val,"[");
								 strcat(val,$3);
								 strcat(val,"]");
								 $$.ctx=strdup(val);						 
								 $$.type=k;
								 $$.v=getval($1,a);                                                          
							 }
            }

;

INST_IF : A ELSE { 	
                    
					if($2==-1){
						ajour_quad(deb_else,1,tmpElse);
						po = pos + 1;
						sprintf(tmp,"%d",po); 
						ajour_quad(BR,1,tmp);
					}
					
}
;
A : B mc_dpoint sdl SUIT_INST{
					po = pos + 1;
					sprintf(tmp,"%d",po); 
					ajour_quad(Fin_if,1,tmp);
					
}
;
B : mc_if mc_parouv CONDITION mc_parfer{
				//jnsp si ilya le else 
				deb_else = qc;
				Fin_if = qc;
				
}
;
INST_FORA : FORA sdl SUIT_INST{
						   qc = quadr("+",valll,"1",valll);	
						   qc = quadr("BR","","vide","vide");
						   qc = ajour_quad(qc,1,tmpdb);
						   po = pos+1;
						   sprintf(tmp,"%d",po); 
                           ajour_quad(Fin_for1,1,tmp);
						   ajour_quad(Fin_for2,1,tmp);
						   
}
;
FORA : mc_for spt IDF spt mc_inrange mc_parouv nbrentier vg nbrentier mc_parfer mc_dpoint{
							    qc = quadr("=",$7,"vide",$3);
								qc = quadr("BL","",$3,$7);
								sprintf(tmpdb,"%d",pos); //indice du debut de la condition du for
								Fin_for1 = qc;
								qc = quadr("BGE","",$3,$9);
								Fin_for2 = qc;
								strcpy(valll,$3);								
}
;
INST_FORB : FORB sdl SUIT_INST{
				           qc = quadr("+",valll,"1",valll);	
						   qc = quadr("BR","","vide","vide");
						   ajour_quad(qc,1,tmpdb);
						   po = pos+1;
						   sprintf(tmp,"%d",po); 
                           ajour_quad(Fin_for1,1,tmp);
						   ajour_quad(Fin_for2,1,tmp);
};
FORB: mc_for spt IDF spt mc_in spt IDF mc_dpoint{
			u=t;
			while(u!=0){
				if(strcmp($7,u->name)==0){
					u->suiv=0;
					trv1 = 1;	
					qc = quadr("=","0","vide",$3);
					qc = quadr("BL","",$3,"0");
					sprintf(tmpdb,"%d",pos); //indice du debut de la condition du for
					Fin_for1 = qc;
					qc = quadr("BGE","",$3,u->size);
					Fin_for2 = qc;
					strcpy(valll,$3);	
				}
				u=u->suiv;
			}
			if(!trv1) {printf(">> Err sem : %s est non iterable\n",$7);return 0;}

};
INST_WHILE : WHILEA sdl SUIT_INST{
				qc = quadr("BR","","vide","vide");
				ajour_quad(qc,1,tmpdb);
				po=pos+1;
				sprintf(tmp,"%d",po); 
				ajour_quad(Fin_while,1,tmp);
}                           
;
WHILEA : mc_while mc_parouv CONDITION mc_parfer mc_dpoint{
				 Fin_while = qc;	     
};

SUIT_INST: sptt INST SUIT_INST
          |sptt INST
;
ELSE : ELSEA SUIT_INST {$$=-1;}
       |{printf("");}
;
ELSEA : mc_else mc_dpoint sdl{BR=quadr("BR","","vide","vide");
								po = pos + 1;
								sprintf(tmpElse,"%d",po);}
CONDITION : EXPRESSION separation mc_inf separation EXPRESSION {
						 $1.ctx=strdup($$.ctx); 
						 qc = quadr("BGE","",$1.ctx,$5.ctx);
						 if(!strcmp(tmpdb,""))sprintf(tmpdb,"%d",pos); //indice du debut de la condition

			}
           |EXPRESSION separation mc_infeq separation EXPRESSION { 
		                 $1.ctx=strdup($$.ctx);
						 qc = quadr("BG","",$1.ctx,$5.ctx);
						 if(!strcmp(tmpdb,""))sprintf(tmpdb,"%d",pos); //indice du debut de la condition
			}
           |EXPRESSION separation mc_sup separation EXPRESSION { 
		                 $1.ctx=strdup($$.ctx);
						 qc = quadr("BLE","",$1.ctx,$5.ctx);
						 if(!strcmp(tmpdb,""))sprintf(tmpdb,"%d",pos); //indice du debut de la condition
			}
           |EXPRESSION separation mc_supeq separation EXPRESSION {
		                 $1.ctx=strdup($$.ctx);
						 qc = quadr("BL","",$1.ctx,$5.ctx);
						 if(!strcmp(tmpdb,""))sprintf(tmpdb,"%d",pos); //indice du debut de la condition		 
            }
           |EXPRESSION separation mc_equal separation EXPRESSION {
		                 $1.ctx=strdup($$.ctx);
						 qc = quadr("BNE","",$1.ctx,$5.ctx);
						 if(!strcmp(tmpdb,""))sprintf(tmpdb,"%d",pos); //indice du debut de la condition

            }
           |EXPRESSION separation mc_dif separation EXPRESSION { 
		                 $1.ctx=strdup($$.ctx);
						 qc = quadr("BE","",$1.ctx,$5.ctx);
						 if(!strcmp(tmpdb,""))sprintf(tmpdb,"%d",pos); //indice du debut de la condition
			}
           |EXPRESSION separation mc_or separation EXPRESSION{ 
	               	     $1.ctx=strdup($$.ctx);
						 deb1 = quadr("BNZ","",$1.ctx,"vide");//debut du and
						 if(!strcmp(tmpdb,""))sprintf(tmpdb,"%d",pos); //indice du debut de la condition			 
						 deb2 = quadr("BNZ","",$5.ctx,"vide");
						 qc = quadr("=","0","vide","tmp_cond_or");
						 BR = quadr("BR","","vide","vide");
						 qc = quadr("=","1","vide","tmp_cond_or");
						 sprintf(tmp,"%d",pos);
						 qc = quadr("BZ","","tmp_cond_or","vide");
						 ajour_quad(deb1,1,tmp);
						 ajour_quad(deb2,1,tmp);
						 sprintf(tmp,"%d",pos);
						 ajour_quad(BR,1,tmp);

            }
           |EXPRESSION separation mc_and separation EXPRESSION { 
		                 $1.ctx=strdup($$.ctx);
						 deb1 = quadr("BZ","",$1.ctx,"vide");//debut du and
						 if(!strcmp(tmpdb,""))sprintf(tmpdb,"%d",pos); //indice du debut de la condition
						 deb2 = quadr("BZ","",$5.ctx,"vide");
						 qc = quadr("=","1","vide","tmp_cond_and");
						 BR = quadr("BR","","vide","vide");
						 qc = quadr("=","0","vide","tmp_cond_and");
						 sprintf(tmp,"%d",pos);
						 qc = quadr("BZ","","tmp_cond_and","vide");
						 ajour_quad(deb1,1,tmp);
						 ajour_quad(deb2,1,tmp);
						 sprintf(tmp,"%d",pos);
						 ajour_quad(BR,1,tmp);

			}
           |mc_not separation EXPRESSION { 
						 deb1 = quadr("BZ","",$3.ctx,"vide");//debut du not
						 if(!strcmp(tmpdb,""))sprintf(tmpdb,"%d",pos); //indice du debut de la condition
						 qc = quadr("=","0","vide","tmp_cond_not");
						 BR = quadr("BR","","vide","vide");
						 qc = quadr("=","1","vide","tmp_cond_not");
						 sprintf(tmp,"%d",pos);
						 qc = quadr("BZ","","tmp_cond_not","vide");
						 ajour_quad(deb1,1,tmp);
						 sprintf(tmp,"%d",pos);
						 ajour_quad(BR,1,tmp);
			}
           ;
separation : spt
            |;

%%
main ()
{
   yyparse(); 
   afficher(b,c,a);
   afficher_qdr(p);

 }
 yywrap ()
 {}
int yyerror (char *msg ) { 
        printf ("Erreur syntaxique, ligne %d, colonne %d \n",yylineo,col); 
        return 1; }

 
