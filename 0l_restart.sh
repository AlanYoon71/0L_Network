#!/bin/bash
PATH=$PATH:/home/node/bin
export TIME=`date +%Y-%m-%dT%I:%M:%S`
echo ""
echo "$TIME [INFO] Script starts."
J=1
K=10
while [ $J -lt $K ]
do
    export MIN=`date "+%M"`
    ACTION1=20
    if [ $MIN == $ACTION1 ]
    then
        export TIME=`date +%Y-%m-%dT%I:%M:%S`
        export syn1=`curl 127.0.0.1:9101/metrics 2> /dev/null | grep diem_state_sync_version{type=\"highest\"} | grep -o '[0-9]*'`
        export round1=`curl 127.0.0.1:9101/metrics 2> /dev/null | grep "diem_consensus_current_round" | grep -o '[0-9]*'`
        sleep 0.1
        if [ -z "$syn1" ]
        then
            export syn1=`curl 127.0.0.1:9101/metrics 2> /dev/null | grep diem_state_sync_version{type=\"target\"} | grep -o '[0-9]*'`
        fi
        export syn11=`curl 127.0.0.1:9101/metrics 2> /dev/null | grep diem_state_sync_version{type=\"synced\"} | grep -o '[0-9]*'`
        sleep 0.1
        if [ "$round1" -gt 0 ]
        then
            if [ -z "$syn1" ]
            then
                echo "$TIME [WARN] >>> Validator already stopped!! <<<"
                pgrep diem-node || nohup ~/bin/diem-node --config ~/.0L/validator.node.yaml >> ~/.0L/logs/validator.log 2>&1 > /dev/null &
                sleep 1
                BB=`pgrep diem-node`
                sleep 0.1
                if [ -z "$BB" ]
                then
                    echo -e "$TIME [ERROR] \e[1m\e[35m>>> Failed to restart.. Trying to restore DB now. <<<\e[0m"
                    rm -rf ~/.0L/db && pgrep diem-node || ~/bin/ol restore >> ~/.0L/logs/restore.log 2>&1 > /dev/null &
                    sleep 10
                    nohup ~/bin/diem-node --config ~/.0L/validator.node.yaml >> ~/.0L/logs/validator.log 2>&1 > /dev/null &
                    sleep 2
                    export TIME=`date +%Y-%m-%dT%I:%M:%S`
                    EE=`pgrep diem-node`
                    if [ -z "$EE" ]
                    then
                        echo -e "$TIME [ERROR] \e[1m\e[35m>>> Failed to restore DB. You need to check node status manually. <<<\e[0m"
                    else
                        echo -e "$TIME [INFO] \e[1m\e[32m========= Restored DB from network and restarted! =========\e[0m"
                    fi
                else
                    echo -e "$TIME [INFO] \e[1m\e[32m========= Validator restarted!! =========\e[0m"
                fi
            else
                echo "$TIME [INFO] Block  height : $syn1"
                if [ -z "$syn11" ]
                then
                    export syn11=`curl 127.0.0.1:9101/metrics 2> /dev/null | grep diem_state_sync_version{type=\"synced\"} | grep -o '[0-9]*'`
                else
                    export LAG=`expr $syn11 - $syn1`
                    if [ "$LAG" -gt -200 ]
                    then
                        echo "$TIME [INFO] Synced height : $syn11 Fully synced."
                    else
                        echo -e "$TIME [INFO] Synced height : $syn11 Lag : \e[1m\e[31m$LAG\e[0m"
                    fi
                fi
            fi
        else
            export round1=0
        fi
        sleep 1760
    fi
    export MIN=`date "+%M"`
    ACTION2=50
    if [ $MIN == $ACTION2 ]
    then
        if [ -z "$syn1" ] ; then syn1=0 ; fi
        if [ -z "$syn11" ] ; then syn11=0 ; fi
        export TIME=`date +%Y-%m-%dT%I:%M:%S`
        export syn2=`curl 127.0.0.1:9101/metrics 2> /dev/null | grep diem_state_sync_version{type=\"highest\"} | grep -o '[0-9]*'`
        export round2=`curl 127.0.0.1:9101/metrics 2> /dev/null | grep "diem_consensus_current_round" | grep -o '[0-9]*'`
        sleep 0.1
        if [ -z "$syn2" ]
        then
            export syn2=`curl 127.0.0.1:9101/metrics 2> /dev/null | grep diem_state_sync_version{type=\"target\"} | grep -o '[0-9]*'`
        fi
        export syn22=`curl 127.0.0.1:9101/metrics 2> /dev/null | grep diem_state_sync_version{type=\"synced\"} | grep -o '[0-9]*'`
        sleep 0.1
        if [ "$round2" -gt 0 ]
        then
            if [ -z "$syn2" ]
            then
                echo "$TIME [WARN] >>> Validator already stopped!! <<<"
                pgrep diem-node || nohup ~/bin/diem-node --config ~/.0L/validator.node.yaml >> ~/.0L/logs/validator.log 2>&1 > /dev/null &
                sleep 1
                BB=`pgrep diem-node`
                sleep 0.1
                export TIME=`date +%Y-%m-%dT%I:%M:%S`
                if [ -z "$BB" ]
                then
                    echo -e "$TIME [ERROR] \e[1m\e[35m>>> Failed to restart.. Trying to restore DB now. <<<\e[0m"
                    rm -rf ~/.0L/db && pgrep diem-node || ~/bin/ol restore >> ~/.0L/logs/restore.log 2>&1 > /dev/null &
                    sleep 10
                    nohup ~/bin/diem-node --config ~/.0L/validator.node.yaml >> ~/.0L/logs/validator.log 2>&1 > /dev/null &
                    sleep 2
                    export TIME=`date +%Y-%m-%dT%I:%M:%S`
                    EE=`pgrep diem-node`
                    if [ -z "$EE" ]
                    then
                        echo -e "$TIME [ERROR] \e[1m\e[35m>>> Failed to restore DB. You need to check node status manually. <<<\e[0m"
                    else
                        echo -e "$TIME [INFO] \e[1m\e[32m========= Restored DB from network and restarted! =========\e[0m"
                    fi
                else
                    echo -e "$TIME [INFO] \e[1m\e[32m========= Validator restarted!! =========\e[0m"
                fi
            else
                echo "$TIME [INFO] Block  height : $syn2"
                if [ -z "$syn22" ]
                then
                    export syn22=`curl 127.0.0.1:9101/metrics 2> /dev/null | grep diem_state_sync_version{type=\"synced\"} | grep -o '[0-9]*'`
                else
                    export LAG=`expr $syn22 - $syn2`
                    if [ "$LAG" -gt -200 ]
                    then
                        echo "$TIME [INFO] Synced height : $syn22 Fully synced."
                    else
                        echo -e "$TIME [INFO] Synced height : $syn22 Lag : \e[1m\e[31m$LAG\e[0m"
                    fi
                    export TIME=`date +%Y-%m-%dT%I:%M:%S`
                    if [ -z "$syn11" ]
                    then
                        echo "$TIME [INFO] No comparison data right now."
                    else
                        if [ -z "$syn1" ]
                        then
                            echo "$TIME [INFO] No comparison data right now."
                        else
                            export NDIFF=`expr $syn2 - $syn1`
                            export LDIFF=`expr $syn22 - $syn11`
                            export NTPS=$(echo "scale=2; $NDIFF / 1800" | bc)
                            sleep 0.1
                            export LTPS=$(echo "scale=2; $LDIFF / 1800" | bc)
                            sleep 0.1
                            export SPEED=$(echo "scale=2; $NTPS - $LTPS" | bc)
                            export TIME=`date +%Y-%m-%dT%I:%M:%S`
                            if [ "$SPEED" == 0 ]
                            then
                                echo "$TIME [INFO] Network TPS  : $NTPS[tx/s]"
                                echo "$TIME [INFO] Local   TPS  : $LTPS[tx/s]"
                                if [ "$NDIFF" == 0 ] ; then echo -e "$TIME [ERROR] \e[1m\e[31m>>> Network stopped!! <<<\e[0m" ; fi
                            else
                                if [ -z "$syn1" ]
                                then
                                    echo "$TIME [INFO] No comparison data right now."
                                else
                                    echo "$TIME [INFO] Network TPS  : $NTPS[tx/s]"
                                    echo "$TIME [INFO] Local   TPS  : $LTPS[tx/s]"
                                    if [ "$LDIFF" -lt 500 ]
                                    then
                                        echo -e "$TIME [WARN] \e[1m\e[31m>>> Local speed is too slow to sync!! <<<\e[0m"
                                        echo -e "$TIME [WARN] \e[1m\e[31m>>> Validator needs to be restarted to recover syncing speed. <<<\e[0m"
                                    else
                                        if [ "$LDIFF" -gt "$NDIFF" ]
                                        then
                                            if [ "$LAG" -lt -500 ]
                                            then
                                                export CATCH=$(echo "scale=2; ( $LAG / $SPEED ) / 3600" | bc)
                                                echo -e "$TIME [INFO] Remained catchup time : \e[1m\e[31m$CATCH\e[0m[Hr]"
                                            fi
                                        fi
                                    fi
                                fi
                            fi
                            SEEK1=`tail -4 ~/.0L/logs/tower.log |grep "Success: Proof committed to chain"`
                            if [ -z "$SEEK1" ]
                            then
                                echo -e "$TIME [ERROR] \e[1m\e[31m>>> Tower failed to submit a last proof! <<<\e[0m"
                                SEEK3=`tail -2 ~/.0L/logs/tower.log | sed -n 1p | grep -o '[0-9]*'`
                            else
                                SEEK2=`tail -2 ~/.0L/logs/tower.log | sed -n 1p | grep -o '[0-9]*'`
                                if [ -z "$SEEK2" ] ; then SEEK2=0 ; fi
                                if [ -z "$SEEK3" ] ; then SEEK3=0 ; fi
                                CHECKTOWER=`expr $SEEK2 - $SEEK3`
                                if [ "$CHECKTOWER" -gt 0 ]
                                then
                                    echo -e "$TIME [INFO] Tower is mining normally. \e[1m\e[32mProof # $SEEK2 \e[0m"
                                else
                                    echo -e "$TIME [ERROR] \e[1m\e[31m>>> Tower mining has been unsuccessful for at least an hour. <<<\e[0m"
                                fi
                                SEEK3=`tail -2 ~/.0L/logs/tower.log | sed -n 1p | grep -o '[0-9]*'`
                            fi
                        fi
                    fi
                fi
            fi
        else
            export round2=0
        fi
        sleep 560
    fi
    export MIN=`date "+%M"`
    ACTION3=59
    if [ $MIN == $ACTION3 ]
    then
        RD=`expr $round2 - $round1`
        if [ "$RD" -lt 2 ]
        then
            export TIME=`date +%Y-%m-%dT%I:%M:%S`
            echo -e "$TIME [ERROR] \e[1m\e[35m|||||| Consensus round stuck! You are at $round2 round. ||||||\e[0m"
            if [ "$LDIFF" -lt 500 ]
            then
                PID=$(pgrep diem-node) && kill -TERM $PID &> /dev/null && sleep 0.5 && PID=$(pgrep diem-node) && kill -TERM $PID &> /dev/null
                sleep 10
                export D=`pgrep diem-node`
                if [ -z "$D" ]
                then
                    export TIME=`date +%Y-%m-%dT%I:%M:%S`
                    echo "$TIME [INFO] Validator stopped for restarting!"
                fi
            else
                if [ -z "$syn1" ] ; then syn1=0 ; fi
                if [ -z "$syn2" ] ; then syn2=0 ; fi
                RR=`expr $syn2 - $syn1`
                if [ "$RR" -lt 2 ]
                then
                    CONVERT=`ps -ef|grep "diem-node --config /home/node/.0L/validator.node.yaml" | awk '/bin/{print $2}'`
                    export TIME=`date +%Y-%m-%dT%I:%M:%S`
                    if [ -z "$CONVERT" ]
                    then
                        ZZ=`pgrep diem-node`
                        sleep 0.1
                        if [ -z "$ZZ" ]
                        then
                            echo "$TIME [WARN] >>> Validator already stopped!! <<<"
                        else
                            echo "$TIME [INFO] ========= Fullnode is running.  ========="
                        fi
                    else
                        if [ "$syn1" -gt 0 ]
                        then
                            echo -e "$TIME [ERROR] \e[1m\e[35m|||||| Network block height stuck! ||||||\e[0m"
                            PID=$(pgrep diem-node) && kill -TERM $PID &> /dev/null && sleep 0.5 && PID=$(pgrep diem-node) && kill -TERM $PID &> /dev/null
                            sleep 10
                            export D=`pgrep diem-node`
                            if [ -z "$D" ]
                            then
                                export TIME=`date +%Y-%m-%dT%I:%M:%S`
                                echo "$TIME [INFO] Validator stopped for restarting!"
                            fi
                        else
                            echo "$TIME [INFO] No comparison data right now."
                        fi
                    fi
                else
                    if [ "$syn1" -gt 0 ]
                    then
                        export TIME=`date +%Y-%m-%dT%I:%M:%S`
                        echo -e "$TIME [INFO] \e[1m\e[32mNetwork is alive! \e[0m"
                        if [ "$LAG" -gt -5000 ]
                        then
                            CONVERT=`ps -ef|grep "diem-node --config /home/node/.0L/validator.node.yaml" | awk '/bin/{print $2}'`
                            if [ -z "$CONVERT" ]
                            then
                                PID=$(pgrep diem-node) && kill -TERM $PID &> /dev/null && sleep 0.5 && PID=$(pgrep diem-node) && kill -TERM $PID &> /dev/null
                                sleep 10
                                export D=`pgrep diem-node`
                                if [ -z "$D" ]
                                then
                                    export TIME=`date +%Y-%m-%dT%I:%M:%S`
                                    echo "$TIME [INFO] Fullnode stopped for converting mode!"
                                fi
                            fi
                        fi
                    fi
                fi
            fi
        else
            export TIME=`date +%Y-%m-%dT%I:%M:%S`
            echo -e "$TIME [INFO] Consensus round is increasing normally. You are at \e[1m\e[32m$round2 \e[0mround."
        fi
        sleep 40
    fi
    export MIN=`date "+%M"`
    ACTION4=00
    if [ $MIN == $ACTION4 ]
    then
        export LL=`pgrep diem-node`
        if [ -z "$LL" ]
        then
            if [ -z "$LAG" ] ; then LAG=-10000 ; fi
            if [ "$LAG" -gt -5000 ]
            then
                pgrep diem-node || nohup ~/bin/diem-node --config ~/.0L/validator.node.yaml >> ~/.0L/logs/validator.log 2>&1 > /dev/null &
                sleep 5
                CC=`pgrep diem-node`
                export TIME=`date +%Y-%m-%dT%I:%M:%S`
                if [ -z "$CC" ]
                then
                    echo -e "$TIME [ERROR] \e[1m\e[35m>>> Failed to restart.. Trying to restore DB now. <<<\e[0m"
                    rm -rf ~/.0L/db && pgrep diem-node > /dev/null || ~/bin/ol restore >> ~/.0L/logs/restore.log 2>&1 > /dev/null &
                    sleep 10
                    nohup ~/bin/diem-node --config ~/.0L/validator.node.yaml >> ~/.0L/logs/validator.log 2>&1 > /dev/null &
                    sleep 2
                    export TIME=`date +%Y-%m-%dT%I:%M:%S`
                    KK=`pgrep diem-node`
                    if [ -z "$KK" ]
                    then
                        echo -e "$TIME [ERROR] \e[1m\e[35m>>> Failed to restore DB. You need to check node status manually. <<<\e[0m"
                    else
                        echo -e "$TIME [INFO] \e[1m\e[32m========= Restored DB from network and restarted! =========\e[0m"
                    fi
                else
                    echo -e "$TIME [INFO] \e[1m\e[32m========= Validator restarted!! =========\e[0m"
                fi
            else
                if [ "$syn11" -gt 0 ]
                then
                    pgrep diem-node || nohup ~/bin/diem-node --config ~/.0L/fullnode.node.yaml >> ~/.0L/logs/fullnode.log 2>&1 > /dev/null &
                    sleep 5
                    CC=`pgrep diem-node`
                    export TIME=`date +%Y-%m-%dT%I:%M:%S`
                    if [ -z "$CC" ]
                    then
                        echo -e "$TIME [ERROR] \e[1m\e[35m>>> Failed to restart.. Trying to restore DB now. <<<\e[0m"
                        rm -rf ~/.0L/db && pgrep diem-node > /dev/null || ~/bin/ol restore >> ~/.0L/logs/restore.log 2>&1 > /dev/null &
                        sleep 10
                        nohup ~/bin/diem-node --config ~/.0L/fullnode.node.yaml >> ~/.0L/logs/fullnode.log 2>&1 > /dev/null &
                        sleep 2
                        export TIME=`date +%Y-%m-%dT%I:%M:%S`
                        KK=`pgrep diem-node`
                        if [ -z "$KK" ]
                        then
                            echo -e "$TIME [ERROR] \e[1m\e[35m>>> Failed to restore DB. You need to check node status manually. <<<\e[0m"
                        else
                            echo -e "$TIME [INFO] \e[1m\e[32m========= Restored DB from network and restarted! =========\e[0m"
                        fi
                    else
                        echo -e "$TIME [INFO] \e[1m\e[33m========= Validator restarted as fullnode mode. =========\e[0m"
                    fi
                else
                    pgrep diem-node || nohup ~/bin/diem-node --config ~/.0L/validator.node.yaml >> ~/.0L/logs/validator.log 2>&1 > /dev/null &
                    sleep 5
                    CC=`pgrep diem-node`
                    export TIME=`date +%Y-%m-%dT%I:%M:%S`
                    if [ -z "$CC" ]
                    then
                        echo -e "$TIME [ERROR] \e[1m\e[35m>>> Failed to restart.. Trying to restore DB now. <<<\e[0m"
                        rm -rf ~/.0L/db && pgrep diem-node > /dev/null || ~/bin/ol restore >> ~/.0L/logs/restore.log 2>&1 > /dev/null &
                        sleep 10
                        nohup ~/bin/diem-node --config ~/.0L/validator.node.yaml >> ~/.0L/logs/validator.log 2>&1 > /dev/null &
                        sleep 2
                        export TIME=`date +%Y-%m-%dT%I:%M:%S`
                        KK=`pgrep diem-node`
                        if [ -z "$KK" ]
                        then
                            echo -e "$TIME [ERROR] \e[1m\e[35m>>> Failed to restore DB. You need to check node status manually. <<<\e[0m"
                        else
                            echo -e "$TIME [INFO] \e[1m\e[32m========= Restored DB from network and restarted! =========\e[0m"
                        fi
                    else
                        echo -e "$TIME [INFO] \e[1m\e[32m========= Validator restarted!! =========\e[0m"
                    fi
                fi
            fi
        else
            CONVERT=`ps -ef|grep "diem-node --config /home/node/.0L/fullnode.node.yaml" | awk '/bin/{print $2}'`
            if [ -z "$CONVERT" ]
            then
                export TIME=`date +%Y-%m-%dT%I:%M:%S`
                echo "$TIME [INFO] ========= Validator is running. ========="
            else
                export syn3=`curl 127.0.0.1:9101/metrics 2> /dev/null | grep diem_state_sync_version{type=\"highest\"} | grep -o '[0-9]*'`
                sleep 0.1
                if [ -z "$syn3" ]
                then
                    export syn3=`curl 127.0.0.1:9101/metrics 2> /dev/null | grep diem_state_sync_version{type=\"target\"} | grep -o '[0-9]*'`
                fi
                export syn33=`curl 127.0.0.1:9101/metrics 2> /dev/null | grep diem_state_sync_version{type=\"synced\"} | grep -o '[0-9]*'`
                sleep 0.1
                GGG=`expr $syn3 - $syn33`
                if [ "$GGG" -lt 1000 ]
                then
                    PID=$(pgrep diem-node) && kill -TERM $PID &> /dev/null && sleep 0.5 && PID=$(pgrep diem-node) && kill -TERM $PID &> /dev/null
                    sleep 10
                    export D=`pgrep diem-node`
                    if [ -z "$D" ]
                    then
                        export TIME=`date +%Y-%m-%dT%I:%M:%S`
                        echo "$TIME [INFO] Catchup completed! Converting fullnode to validator."
                        pgrep diem-node || nohup ~/bin/diem-node --config ~/.0L/validator.node.yaml >> ~/.0L/logs/validator.log 2>&1 > /dev/null &
                        sleep 5
                        CC=`pgrep diem-node`
                        export TIME=`date +%Y-%m-%dT%I:%M:%S`
                        if [ -z "$CC" ]
                        then
                            echo -e "$TIME [ERROR] \e[1m\e[35m>>> Failed to restart.. Trying to restore DB now. <<<\e[0m"
                            rm -rf ~/.0L/db && pgrep diem-node > /dev/null || ~/bin/ol restore >> ~/.0L/logs/restore.log 2>&1 > /dev/null &
                            sleep 10
                            nohup ~/bin/diem-node --config ~/.0L/validator.node.yaml >> ~/.0L/logs/validator.log 2>&1 > /dev/null &
                            sleep 2
                            export TIME=`date +%Y-%m-%dT%I:%M:%S`
                            KK=`pgrep diem-node`
                            if [ -z "$KK" ]
                            then
                                echo -e "$TIME [ERROR] \e[1m\e[35m>>> Failed to restore DB. You need to check node status manually. <<<\e[0m"
                            else
                                echo -e "$TIME [INFO] \e[1m\e[32m========= Restored DB from network and restarted! =========\e[0m"
                            fi
                        else
                            echo -e "$TIME [INFO] \e[1m\e[32m========= Validator restarted!! =========\e[0m"
                        fi
                    fi
                else
                    export TIME=`date +%Y-%m-%dT%I:%M:%S`
                    echo "$TIME [INFO] ========= Fullnode is running.  ========="
                fi
            fi
        fi
        sleep 1160
    fi
    export NN=`pgrep tower`
    sleep 0.1
    if [ -z "$NN" ]
    then
        export TIME=`date +%Y-%m-%dT%I:%M:%S`
        echo -e "$TIME [ERROR] \e[1m\e[35m>>> Tower disconnected!! <<<\e[0m"
        nohup ~/bin/tower -o start >> ~/.0L/logs/tower.log 2>&1 &
        sleep 2
        export QQ=`pgrep tower`
        if [ -n "$QQ" ]
        then
            echo -e "$TIME [INFO] ========= \e[1m\e[33m  Tower restarted.   \e[0m========="
        fi
    fi
    sleep 5
done