{
module Grammar where
import Tokens
}

%name parseCalc Externdecl
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
    ','       { TokenCcomma}
    '*'       { TokenCasterisk}
    '('       { TokenCLParen}
    ')'       { TokenCRParen}
    IDENT     { TokenCSym $$}

%%

Externdecl  : extern IDENT IDENT '(' Params ')'   {Ext $3 $2 $5}

Params  : IDENT                                   {$1 ++ []}
        | IDENT ',' Params                        {$1 ++ " and " ++ $3}

{

parseError :: [Token] -> a
parseError _ = error "Parse error"

data Extern = Ext String String String
         deriving Show
}
