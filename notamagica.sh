#!/usr/bin/env bash
set -o errexit; set -o errtrace; set -o pipefail # Exit on errors
# Uncomment line below for debugging:
#PS4=$'+ $(tput sgr0)$(tput setaf 4)DEBUG ${FUNCNAME[0]:+${FUNCNAME[0]}}$(tput bold)[$(tput setaf 6)${LINENO}$(tput setaf 4)]: $(tput sgr0)'; set -o xtrace
__deps=( "sed" "xargs" "pdftotext" )
for dep in ${__deps[@]}; do hash $dep >& /dev/null || (echo "$dep was not found. Please install poppler and try again." && exit 1); done

Blue='\e[01;34m'
White='\e[01;37m'
Red='\e[01;31m'
Green='\e[01;32m'
Reset='\e[00m'

function usage {
    echo -e "${Blue}Para usar, coloque: \n" \
            "${Bold}\t- os pdfs das notas,\n"\
            "\t- o relatório do timeneye,\n"\
            "\t- e as aprovações dos gestores,\n"\
            "\tTudo em um diretório só.${Reset}\n" \
            "\t${Red}IMPORTANTE: Não mude o nome de nenhum arquivo, \n"\
            "\tdeixe tudo como veio (exceto as aprovações, é claro).${Reset}"
    echo -e "\n\n${Blue}Depois, rode o comando:\n${Reset}"\
            "${Bold}${Green}\t./notamagica.sh <SEU_NOME_COMPLETO>${Reset}\n"\
            "${Blue}\tLembrando que o nome deve ser sem espaços de acordo com o PC.${Reset}\n"\
            "\tO script deverá ser executado ${Bold}de dentro do díretório${Reset} com os arquivos!"
    exit 1
}

[[ -z $1 || ${1} == '-h' || ${1} == '--help' ]] && usage


MES=$(date --date="-1 month" +%Y%m)
NOME=${1}

echo -e "${Blue}Renomeando Timeneye...${Reset}"
mv timeneye_member_report* Timeneye-${NOME}-${MES}.PDF

echo -e "\n${Blue}Renomeando Notas Fiscais...${Reset}"
for nota in nota_*.pdf; do
    projeto=$(pdftotext -r 300 -x 339 -y 944 -W 1041 -H 152 -nopgbrk ${nota} - | xargs | sed 's/([A-Za-z0-9 ]*) //')
    echo -e "${Green}Nota ${nota} é do projeto ${projeto}.${Reset}"
    mv ${nota} "NF-${NOME}-${projeto}-${MES}.PDF"
done

echo -e "\n${Blue}Renomeando aprovações...${Reset}"
sleep 2
echo -e "${Green}Pegadinha!${Reset} Não tenho como fazer isso... :P (ainda)"
echo -e
echo -e "\n\n${Red}Agora vá, corra e envie o formulário antes que o PeopleCare venha nos pegar!${Reset}"

