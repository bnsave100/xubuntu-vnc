#!/bin/bash
### @accetto (https://github.com/accetto) (https://hub.docker.com/u/accetto/)

# ARG_OPTIONAL_SINGLE([lines],[n],[Number of header lines to display],[10])
# ARG_POSITIONAL_SINGLE([file],[File containing the commands])
# ARG_POSITIONAL_SINGLE([line],[Number of the line to execute],[0])
# ARG_VERSION([echo $0 v19.06.23])
# ARG_HELP([Displays the file head and executes the chosen line, removing the first occurrence of '#' and trimming the line from left first.\nProviding the line number argument skips the interaction and executes the given line directly.])
# ARG_OPTIONAL_BOOLEAN([echo],[],[Just print the command line to be executed])
# ARGBASH_SET_INDENT([  ])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.8.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info


die()
{
  local _ret=$2
  test -n "$_ret" || _ret=1
  test "$_PRINT_HELP" = yes && print_help >&2
  echo "$1" >&2
  exit ${_ret}
}


begins_with_short_option()
{
  local first_option all_short_options='nvh'
  first_option="${1:0:1}"
  test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_line="0"
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_lines="10"
_arg_echo="off"


print_help()
{
  printf '%s\n' "Displays the file head and executes the chosen line, removing the first occurrence of '#' and trimming the line from left first.
Providing the line number argument skips the interaction and executes the given line directly."
  printf 'Usage: %s [-n|--lines <arg>] [-v|--version] [-h|--help] [--(no-)echo] <file> [<line>]\n' "$0"
  printf '\t%s\n' "<file>: File containing the commands"
  printf '\t%s\n' "<line>: Number of the line to execute (default: '0')"
  printf '\t%s\n' "-n, --lines: Number of header lines to display (default: '10')"
  printf '\t%s\n' "-v, --version: Prints version"
  printf '\t%s\n' "-h, --help: Prints help"
  printf '\t%s\n' "--echo, --no-echo: Just print the command line to be executed (off by default)"
}


parse_commandline()
{
  _positionals_count=0
  while test $# -gt 0
  do
    _key="$1"
    case "$_key" in
      -n|--lines)
        test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
        _arg_lines="$2"
        shift
        ;;
      --lines=*)
        _arg_lines="${_key##--lines=}"
        ;;
      -n*)
        _arg_lines="${_key##-n}"
        ;;
      -v|--version)
        echo $0 v19.06.23
        exit 0
        ;;
      -v*)
        echo $0 v19.06.23
        exit 0
        ;;
      -h|--help)
        print_help
        exit 0
        ;;
      -h*)
        print_help
        exit 0
        ;;
      --no-echo|--echo)
        _arg_echo="on"
        test "${1:0:5}" = "--no-" && _arg_echo="off"
        ;;
      *)
        _last_positional="$1"
        _positionals+=("$_last_positional")
        _positionals_count=$((_positionals_count + 1))
        ;;
    esac
    shift
  done
}


handle_passed_args_count()
{
  local _required_args_string="'file'"
  test "${_positionals_count}" -ge 1 || _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require between 1 and 2 (namely: $_required_args_string), but got only ${_positionals_count}." 1
  test "${_positionals_count}" -le 2 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect between 1 and 2 (namely: $_required_args_string), but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
}


assign_positional_args()
{
  local _positional_name _shift_for=$1
  _positional_names="_arg_file _arg_line "

  shift "$_shift_for"
  for _positional_name in ${_positional_names}
  do
    test $# -gt 0 || break
    eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
    shift
  done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash

_cmd=""
_input=""
_key=''
_line=$_arg_line
_size=10

[[ ! -f "$_arg_file" ]] && die "FAILED: File \"$_arg_file\" not found!"

_size=$(wc -l < "$_arg_file")
[[ $_size -gt $_arg_lines ]] && _size=$_arg_lines

if [[ $_line -le 0 ]] ; then
  ### output the header numbering the lines
  head -n $_size "$_arg_file" | cat -n

  ### get the line number
  read -rp $'Which line to execute? ' _input
  _input=$(echo $_input | grep -E "^[0-9]+$")
  [[ $_input ]] && _line=$_input || die "INTERRUPTED: Numeric input required!"
  [[ $_line -lt 1 || $_line -gt $_size ]] && die "FAILED: The line number must be from the interval [1..$_size]!"
fi

### get the command line, remove the first '#' and trim it from the left
_cmd=$(sed "${_line}q;d" "$_arg_file")
_cmd=$(echo $_cmd | sed -r -e 's/^\s*#\s*//g')

### display the command to be executed
echo $_cmd

if [[ $_arg_line -eq 0 && "$_arg_echo" = "off" ]] ; then
  ### ask for user confirmation
  read -rp $'Execute the line above? (y) ' -n1 _key
  echo
  [[ "${_key,,}" != "y" ]] && die "INTERRUPTED"
fi

if [[ "$_arg_echo" == "off" ]] ; then
  eval "$_cmd"
fi

# ] <-- needed because of Argbash
