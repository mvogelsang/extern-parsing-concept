{
module Tokens where
}

%wrapper "basic"

$digit = 0-9
$alpha = [a-zA-Z]

tokens :-

  $white+                           ;
  extern                            { \s -> TokenCextern}
  const                             { \s -> TokenCconst}
  volatile                          { \s -> TokenCvolatile}
  signed                            { \s -> TokenCsigned}
  unsigned                          { \s -> TokenCunsigned}
  long                              { \s -> TokenClong}
  short                             { \s -> TokenCshort}
  char                              { \s -> TokenCchar}
  int                               { \s -> TokenCint}
  float                             { \s -> TokenCfloat}
  double                            { \s -> TokenCdouble}
  void                              { \s -> TokenCvoid}
  \.\.\.                            { \s -> TokenCellipsis}
  \,                                { \s -> TokenCcomma}
  \;                                { \s -> TokenCsemicolon}
  [\*]                              { \s -> TokenCasterisk}
  \(                                { \s -> TokenCLParen}
  \)                                { \s -> TokenCRParen}
  \[                                { \s -> TokenCLBracket}
  \]                                { \s -> TokenCRBracket}
  [$alpha \_]([$alpha $digit \_]*)   { \s -> TokenCSym s}



{

-- The token type:
data Token = TokenCextern
           | TokenCconst
           | TokenCvolatile
           | TokenCsigned
           | TokenCunsigned
           | TokenClong
           | TokenCshort
           | TokenCchar
           | TokenCint
           | TokenCfloat
           | TokenCdouble
           | TokenCvoid
           | TokenCcomma
           | TokenCasterisk
           | TokenCLParen
           | TokenCRParen
           | TokenCSym String
           | TokenCellipsis
           | TokenCsemicolon
           | TokenCLBracket
           | TokenCRBracket
           deriving (Eq,Show)

scanTokens = alexScanTokens

}
