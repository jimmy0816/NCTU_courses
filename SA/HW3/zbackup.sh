#!/bin/sh

r_count=$?
cmd_num=$#
dataset=$?
id=$?

Create(){
    if [ $cmd_num -ne 2 ]; then
        r_count=20
    fi
    date=$(date +"%Y-%m-%d")
    time=$(date +"%X")

    cur_count=`cat ~/zsnapshot | grep -c "$dataset "`
    if [ $cur_count -lt $r_count ]; then
        #create snapshot <dataset>@date.time
        echo "$dataset $date $time" >> ~/zsnapshot
        sudo zfs snapshot "$dataset@$date.$time"
    else
        dnum=$(($cur_count - $r_count + 1))
        cat ~/zsnapshot | grep "$dataset " > ~/tmp
        cat ~/zsnapshot | grep -v "$dataset " > ~/tmp2
        cat ~/tmp | sed -e "1,$dnum"'d' >> ~/tmp2
        cat ~/tmp2 | sort -k 2 -t " " > ~/zsnapshot
        rm ~/tmp
        rm ~/tmp2
        echo "$dataset $date $time" >> ~/zsnapshot
        sudo zfs snapshot "$dataset@$date.$time"
    fi    
}

List(){
    cat ~/zsnapshot | grep "$dataset " | awk 'BEGIN{ print "ID  Dataset          Time"} { print NR"   "$1"   "$2" "$3}'

}

Delete(){
    if [ $cmd_num -eq 2 ]; then
        cat ~/zsnapshot | grep -v "$dataset " > ~/tmp
        cp ~/tmp ~/zsnapshot
        rm ~/tmp
    else
        cat ~/zsnapshot | grep "$dataset " > ~/tmp
        cat ~/zsnapshot | grep -v "$dataset " > ~/tmp2
        cat ~/tmp | sed -e "$id,$id"'d' >> ~/tmp2
        cat ~/tmp2 | sort -k 2 -t " " > ~/zsnapshot
        rm ~/tmp
        rm ~/tmp2
    fi
}

case $1 in
    --list)
        dataset=$2
        List;;
    --delete)
        cmd_num=$#
        dataset=$2
        id=$3
        Delete;;
    *)
        cmd_num=$#
        dataset=$1
        r_count=$2
        Create;;
esac


