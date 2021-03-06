#! /bin/bash

clusterName='es-data'

while [ "$1" != "" ]; do
    case $1 in
         --user )
            shift
            username=$1
            ;;
         --env )
            shift
            environment=$1
            ;;
         --index )
            shift
            indexName=$1
            ;;
        --docType )
            shift
            documentType=$1
            ;;
        --alias )
            shift
            alias=$1
            ;;
        --docMappingFile )
            shift
            docMappingFile=$1
            ;;
        --query )
            shift
            query=$1
            ;;
        --update )
            shift
            updateFile=$1
            ;;
        --file )
            shift
            file=$1
            ;;
        --slices )
            shift
            slices=$1
            ;;
        --watch )
            shift
            watch=$1
            ;;
        *)
            usage
            exit 1
    esac
    shift
done

function usage() {
    echo "createIndex --env <environment> --index <index name>"
}

function buildElasticSearchHostName() {
    local _elasticSearchHostName=$1
    local _env=$2
    
    if [ "$_env" == 'local' ]; then
        elasticSearchHostName='http://local.docker:9200/'
    else
        elasticSearchHostName='http://'"$clusterName"'.'"$_env"'.blackbaudcloud.com:9200/'
    fi
    eval $_elasticSearchHostName="'$elasticSearchHostName'"    
}

function buildElasticSearchUrl() {
    local _elasticSearchUrl=$1
    local _env=$2
    local _idxName=$3
    
    buildElasticSearchHostName elasticSearchHostName $_env
    url="$elasticSearchHostName""$_idxName"
    eval $_elasticSearchUrl="'$url'"
}

function buildElasticSearchCatUrl() {
    local _elasticSearchUrl=$1
    local _env=$2

    buildElasticSearchHostName elasticSearchHostName $_env
    url="$elasticSearchHostName"'_cat'
    eval $_elasticSearchUrl="'$url'"
}

function buildElasticSearchReindexUrl() {
    local _elasticSearchUrl=$1
    local _env=$2
    url='http://'"$clusterName"'.'"$_env"'.blackbaudcloud.com:9200/_reindex'
    eval $_elasticSearchUrl="'$url'"
}

function buildElasticSearchUrlToAddNewField() {
    local _elasticSearchUrl=$1
    local _env=$2
    local _idxName=$3
    local _docType=$4
    url='http://'"$clusterName"'.'"$_env"'.blackbaudcloud.com:9200/'"$_idxName"'/_mapping/'"$_docType"
    eval $_elasticSearchUrl="'$url'"
}

function buildSearchUrl() {
    local _elasticSearchUrl=$1
    local _env=$2
    local _idxName=$3
    local _docType=$4

    buildElasticSearchHostName elasticSearchHostName $_env

    url="$elasticSearchHostName""$_idxName"'/'"$_docType"'/_search'
    eval $_elasticSearchUrl="'$url'"    
}

function buildAggregationsQueryUrl() {
    local _elasticSearchUrl=$1
    local _env=$2
    local _idxName=$3
    local _docType=$4

    buildElasticSearchHostName elasticSearchHostName $_env

    url="$elasticSearchHostName""$_idxName"'/'"$_docType"'/_search'
    eval $_elasticSearchUrl="'$url'"  
}

function buildUpdateByQueryUrl() {
    local _elasticSearchUrl=$1
    local _env=$2
    local _idxName=$3
    local _docType=$4
    local _slices=$5
    url='http://'"$clusterName"'.'"$_env"'.blackbaudcloud.com:9200/'"$_idxName"'/'"$_docType"'/_update_by_query'
    eval $_elasticSearchUrl="'$url'"
}

function buildTasksUrl() {
    local _elasticSearchUrl=$1
    local _env=$2
    local _idxName=$3
    local _docType=$4
    url='http://'"$clusterName"'.'"$_env"'.blackbaudcloud.com:9200/_tasks'
    eval $_elasticSearchUrl="'$url'"
}
