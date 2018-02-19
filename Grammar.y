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
	: extern declaration_specifiers declarator ';'       		 { mkexpressiontop $2 $3}

declaration_specifiers
	: storage_class_specifier                          {[SS $1]}
	| storage_class_specifier declaration_specifiers   {[SS $1] ++ $2}
	| type_specifier                                   {[TS $1]}
	| type_specifier declaration_specifiers            {[TS $1] ++ $2}
	| type_qualifier                                   {[TQ $1]}
	| type_qualifier declaration_specifiers            {[TQ $1] ++ $2}

storage_class_specifier
	: extern               {Extern}

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
	: pointer direct_declarator        {Rhalf $1 ($2)}
	| direct_declarator                {Rhalf Nothing ($2)}

direct_declarator
	: IDENT			                                       {Inpar Just Name $1 Nothing Nothing}
	| '(' declarator ')'                               {Inpar Just Type (mkexpressiontop Nothing $2) Nothing}
	| direct_declarator '[' ']'                        {Inpar Just $1 Just Array Nothing}
	| direct_declarator '(' parameter_type_list ')'    {$1 Params $3}
	| direct_declarator '(' ')'                        {$1 Params []}

pointer
	: '*'                                              {Just (Pointer Nothing Nothing)}
	| '*' type_qualifier                               {Just (Pointer $2 Nothing)}
	| '*' pointer                                      {Just (Pointer Nothing $2)}
	| '*' type_qualifier pointer                       {Just (Pointer $2 $3)}

parameter_type_list
	: parameter_list                                   {$1}
	| parameter_list ',' ellipsis                      {$1 ++ [Ellipsis]}

parameter_list
	: parameter_declaration                     			 {[$1]}
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

data Rhalfconvenience = Rhalf MPointer Inpar
data Inpar = Inpar Inner Params

data Ellipsis = Ellipsis
data Param = Either Expression Ellipsis
type Params = Maybe [Expression]
type Result = Maybe ConciseTypeInfo
data Pointer = Pointer Maybe TypeQualifier MPointer
type MPointer = Maybe Pointer
data InnerOpts = Type Expression | Name String Inner
data Array = Array
type Inner = Maybe InnerOpts Maybe Array


data Expression = Expr Result MPointer Inner Params



type ConciseTypeInfo = [UnifiedTypeDescriptors]

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
