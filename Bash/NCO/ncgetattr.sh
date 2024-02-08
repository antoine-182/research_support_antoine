#!/usr/bin/env bash
#
# Command to print the value of an attribute (global or from a variable) in a netcdf file.
# Download this script and put it or link it somewhere in your $PATH, for instance:
# ln -s ~/Download/ncgetattr.sh ~/.local/bin/ncgetattr
# You can then use it anywhere, like `ncgetattr --help`.
#
# Code is mostly taken from https://nco.sourceforge.net/nco.html#Filters-for-ncks
#
# ARG_POSITIONAL_SINGLE([filename],[NetCDF filename],[])
# ARG_POSITIONAL_SINGLE([attribute],[Attribute name],[])
# ARG_POSITIONAL_SINGLE([variable],[Variable name],[global])
# ARG_OPTIONAL_BOOLEAN([metadata],[],[Print metadata as well as value. Filtering to remove metadata and only keep value might not be super robust],[off])
# ARG_HELP([Print the value of a variable attribute. Attribute and variable names can contain regex to obtain multiple values in one command.])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.9.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info
# Generated online by https://argbash.io/generate

cmd_name="ncgetattr"

die()
{
    local _ret="${2:-1}"
    test "${_PRINT_HELP:-no}" = yes && print_help >&2
    echo "$1" >&2
    exit "${_ret}"
}


begins_with_short_option()
{
    local first_option all_short_options='h'
    first_option="${1:0:1}"
    test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_variable="global"
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_metadata="off"


print_help()
{
    printf '%s\n' "Print the value of a variable attribute. Attribute and variable names can contain regex to obtain multiple values in one command."
    printf 'Usage: %s [--(no-)metadata] [-h|--help] <filename> <attribute> [<variable>]\n' "${cmd_name}"
    printf '\t%s\n' "<filename>: NetCDF filename"
    printf '\t%s\n' "<attribute>: Attribute name"
    printf '\t%s\n' "<variable>: Variable name (default: 'global')"
    printf '\t%s\n' "--metadata, --no-metadata: Print metadata as well as value. Filtering to remove metadata and only keep value might not be super robust (off by default)"
    printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
    _positionals_count=0
    while test $# -gt 0
    do
        _key="$1"
        case "$_key" in
            --no-metadata|--metadata)
                _arg_metadata="on"
                test "${1:0:5}" = "--no-" && _arg_metadata="off"
                ;;
            -h|--help)
                print_help
                exit 0
                ;;
            -h*)
                print_help
                exit 0
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
    local _required_args_string="'filename' and 'attribute'"
    test "${_positionals_count}" -ge 2 || _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require between 2 and 3 (namely: $_required_args_string), but got only ${_positionals_count}." 1
    test "${_positionals_count}" -le 3 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect between 2 and 3 (namely: $_required_args_string), but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
}


assign_positional_args()
{
    local _positional_name _shift_for=$1
    _positional_names="_arg_filename _arg_attribute _arg_variable "

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

### END OF CODE GENERATED BY Argbash (sortof) ### ])# [ <-- needed because of Argbash

if [ ! -f "${_arg_filename}" ]; then
    echo "Invalid file ${_arg_filename}"
    exit 1
fi

output="$(ncks --trd -M -m "${_arg_filename}" |
    grep -E -i "^${_arg_variable} attribute [0-9]+: ${_arg_attribute}")"

if [ "${_arg_metadata}" == "off" ]; then
    echo "$output" | sed -nE -s 's/^.*value = (.*)/\1/p'
else
    echo "$output"
fi


# ] <-- needed because of Argbash