" jinja syntax file
" Language: Jinja YAML Template
" Maintainer:Chase Colman <chase@colman.io>
" Author: Armin Ronacher <armin.ronacher@active-4.com>
" Latest Revision: 2013-12-10
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
  finish
endif
  let main_syntax = 'jinja'
endif

syntax case match

" Jinja template built-in tags and parameters (without filter, macro, is and raw, they
" have special threatment)
syn keyword jinjaStatement contained and if else elif is in not or recursive as import

syn keyword jinjaStatement contained is filter skipwhite nextgroup=jinjaFilter
syn keyword jinjaStatement containedin=jinjaTagBlock contained macro skipwhite nextgroup=jinjaFunction
syn keyword jinjaStatement containedin=jinjaTagBlock contained block skipwhite nextgroup=jinjaBlockName

" Variable Names
syn match jinjaVariable contained /[a-zA-Z_][a-zA-Z0-9_]*/
syn keyword jinjaSpecial contained false true none False True None loop super caller varargs kwargs

" Filters
syn match jinjaOperator "|" contained skipwhite nextgroup=jinjaFilter
syn keyword jinjaFilter contained abs attr batch capitalize center default
syn keyword jinjaFilter contained dictsort escape filesizeformat first
syn keyword jinjaFilter contained float forceescape format groupby indent
syn keyword jinjaFilter contained int join last length list lower pprint
syn keyword jinjaFilter contained random replace reverse round safe slice
syn keyword jinjaFilter contained sort string striptags sum
syn keyword jinjaFilter contained title trim truncate upper urlize
syn keyword jinjaFilter contained wordcount wordwrap
syn match jinjaBlockName contained /[a-zA-Z_][a-zA-Z0-9_]*/

" Jinja template constants
syn region jinjaString contained start=/"/ skip=/\\"/ end=/"/
syn region jinjaString contained start=/'/ skip=/\\'/ end=/'/
syn match jinjaNumber contained /[0-9]\+\(\.[0-9]\+\)\?/

" Operators
syn match jinjaOperator contained /[+\-*\/<>=!,:]/
syn match jinjaPunctuation contained /[()\[\]]/
syn match jinjaOperator contained /\./ nextgroup=jinjaAttribute
syn match jinjaAttribute contained /[a-zA-Z_][a-zA-Z0-9_]*/

" Jinja template tag and variable blocks
syn cluster jinjaNestedElement contains=jinjaNested,jinjaNumber,jinjaOperator,
      \jinjaPunctuation,jinjaSpecial,jinjaStatement,jinjaString,jinjaVariable
syn region jinjaNested matchgroup=jinjaDelimiter start="(" end=")" transparent display contained contains=@jinjaNestedElement
syn region jinjaNested matchgroup=jinjaOperator start="\[" end="\]" transparent display contained contains=@jinjaNestedElement
syn region jinjaNested matchgroup=jinjaDelimiter start="{" end="}" transparent display contained contains=@jinjaNestedElement

syn region jinjaVarBlock matchgroup=jinjaVarDelim start=/{{-\?/ end=/-\?}}/
      \ containedin=ALLBUT,jinjaVarBlock,jinjaRaw,jinjaString,jinjaNested contains=@jinjaNestedElement

" Jinja template 'raw' tag
syn region jinjaRaw matchgroup=jinjaRawDelim start="{%\s*raw\s*%}" end="{%\s*endraw\s*%}" containedin=ALLBUT,jinjaVarBlock,jinjaString

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_jinja_syn_inits")
  if version < 508
    let did_jinja_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink jinjaPunctuation jinjaOperator
  HiLink jinjaAttribute Identifier
  HiLink jinjaFunction jinjaFilter

  HiLink jinjaVarDelim PreProc
  HiLink jinjaRawDelim jinjaVarDelim

  HiLink jinjaSpecial Special
  HiLink jinjaOperator Operator
  HiLink jinjaRaw Normal
  HiLink jinjaStatement Statement
  HiLink jinjaDelimiter Delimiter
  HiLink jinjaFilter Function
  HiLink jinjaBlockName Function
  HiLink jinjaVariable Normal
  HiLink jinjaString Constant
  HiLink jinjaNumber Constant

  delcommand HiLink
endif

let b:current_syntax = "jinja"

if main_syntax == 'jinja'
  unlet main_syntax
endif
