{
module Grammar where
import Tokens
}

%name parseCalc external_declaration
%tokentype { Token }
%error { parseError }

%token
    extern    { TokenCextern}
    const     { TokenCconst}
    volatile  { TokenCvolatile}
    signed    { TokenCsigned}
    unsigned  { TokenCunsigned}
    long      { TokenClong}
    short     { TokenCshort}
    char      { TokenCchar}
    int       { TokenCint}
    float     { TokenCfloat}
    double    { TokenCdouble}
    void      { TokenCvoid}
		ellipsis	{ TokenCellipsis}
		','       { TokenCcomma}
    ';'       { TokenCsemicolon}
    '*'       { TokenCasterisk}
		'('       { TokenCLParen}
    ')'       { TokenCRParen}
		'['       { TokenCLBracket}
		']'       { TokenCRBracket}
    IDENT     { TokenCSym $$}

%%

external_declaration
	: extern declaration_specifiers declarator ';'       		 {}

declaration_specifiers
	: storage_class_specifier                          {SS $1 : []}
	| storage_class_specifier declaration_specifiers   {[SS $1] ++ $2}
	| type_specifier                                   {TS $1 : []}
	| type_specifier declaration_specifiers            {[TS $1] ++ $2}
	| type_qualifier                                   {TQ $1 : []}
	| type_qualifier declaration_specifiers            {[TQ $1] ++ $2}

storage_class_specifier
	: extern              {Extern}

type_specifier
	: void                 {Void}
	| char                 {Char}
	| short                {Short}
	| int                  {Int}
	| long                 {Long}
	| float                {Float}
	| double               {Double}
	| signed               {Signed}
	| unsigned             {Unsigned}

type_qualifier
	: const                {Const}
	| volatile             {Volatile}

declarator
	: pointer direct_declarator        {$1 $2}
	| direct_declarator                {$1}

direct_declarator
	: IDENT			                                       {Name $1}
	| '(' declarator ')'                               {Parens $2}
	| direct_declarator '[' ']'                        {$1 Array}
	| direct_declarator '(' parameter_type_list ')'    {$1 Params $3}
	| direct_declarator '(' ')'                        {$1 Params []}

pointer
	: '*'                                              {Pointer }
	| '*' type_qualifier                               {Pointer $2}
	| '*' pointer                                      {Pointer $2}
	| '*' type_qualifier pointer                       {Pointer $2 $3}

parameter_type_list
	: parameter_list                                   {$1}
	| parameter_list ',' ellipsis                      {$1 ++ [Ellipsis]}

parameter_list
	: parameter_declaration                            {$1 : []}
	| parameter_list ',' parameter_declaration         {$1 ++ [$3]}

parameter_declaration
	: declaration_specifiers abstract_declarator       {$1 $2}
	| declaration_specifiers                           {$1}

abstract_declarator
	: pointer                                          {$1}
	| direct_abstract_declarator                       {$1}
	| pointer direct_abstract_declarator               {$1 $2}

direct_abstract_declarator
	: '(' abstract_declarator ')'                              {Parens $2}
	| '[' ']'                                                  {Array}
	| direct_abstract_declarator '[' ']'                       {$1 Array}
	| '(' ')'                                                  {Params []}
	| '(' parameter_type_list ')'                              {Params $2}
	| direct_abstract_declarator '(' ')'                       {$1 Params []}
	| direct_abstract_declarator '(' parameter_type_list ')'   {$1 Params $3}

{

parseError :: [Token] -> a
parseError _ = error "Parse error"

data Name = Name String
data Label  = Label Name TypeOrder
data TypeOrder = HighOrder [TypeOrder] TypeOrder | LowOrder [UnifiedTypeDescriptors]
data UnifiedTypeDescriptors = TS TypeSpecifier
														| SS StorageSpecifier
														| TQ TypeQualifier

data TypeSpecifier = Void
                	| Char
                	| Short
                	| Int
                	| Long
                	| Float
                	| Double
                	| Signed
                	| Unsigned

data StorageSpecifier = Typedef
                        | Extern
                        | Static
                        | Auto
                        | Register

data TypeQualifier  = Const | Volatile




}
