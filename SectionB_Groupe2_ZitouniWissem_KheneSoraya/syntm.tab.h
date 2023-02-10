
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     nbrentier = 258,
     nbrreel = 259,
     cstbool = 260,
     IDF = 261,
     mc_entier = 262,
     mc_reel = 263,
     mc_char = 264,
     mc_bool = 265,
     mc_and = 266,
     mc_or = 267,
     mc_not = 268,
     mc_aff = 269,
     mc_if = 270,
     mc_else = 271,
     mc_for = 272,
     mc_range = 273,
     mc_in = 274,
     mc_while = 275,
     mc_parouv = 276,
     mc_parfer = 277,
     mc_acouv = 278,
     mc_acfer = 279,
     mc_dpoint = 280,
     mc_plus = 281,
     mc_moins = 282,
     mc_mul = 283,
     mc_div = 284,
     mc_inf = 285,
     mc_inrange = 286,
     mc_infeq = 287,
     mc_sup = 288,
     mc_supeq = 289,
     mc_dif = 290,
     mc_equal = 291,
     vg = 292,
     sdl = 293,
     tabul = 294,
     cstchar = 295,
     spt = 296,
     gi = 297,
     err = 298,
     sptt = 299
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 36 "syntm.y"

	int entier; 
	float reel; 
	char *str;
	struct{
	  int type;
	  char *ctx;
	  float v;
    }tt;



/* Line 1676 of yacc.c  */
#line 109 "syntm.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


