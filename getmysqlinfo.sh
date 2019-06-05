#!/bin/bash 
#Name: MySQLMontior.sh 
#From: flashyhl <2015/08/06> 
#Action: Zabbix monitoring mysql plug-in 

MySQlBin=/usr/bin/mysql 
MySQLAdminBin=/usr/bin/mysqladmin 
Host=localhost 
User=mysqlcheck 
Password=mysqlcheck 
  
if [[ $# == 1 ]];then 
    case $1 in 
         Ping) 
            result=`$MySQLAdminBin -u$User -p$Password -h$Host  ping 2>/dev/null |grep alive|wc -l`
            echo $result| grep -v Warning  
        ;;  
         Threads)  
            result=`$MySQLAdminBin -u$User -p$Password -h$Host  status 2>/dev/null |cut -f3 -d":"|cut -f1 -d"Q"`  
            echo $result| grep -v Warning  
        ;;  
         Questions)  
            result=`$MySQLAdminBin -u$User -p$Password -h$Host  status 2>/dev/null |cut -f4 -d":"|cut -f1 -d"S"`  
            echo $result| grep -v Warning  
        ;;  
         Slowqueries)  
            result=`$MySQLAdminBin -u$User -p$Password -h$Host  status 2>/dev/null |cut -f5 -d":"|cut -f1 -d"O"`  
            echo $result| grep -v Warning  
        ;;  
         Qps)  
            result=`$MySQLAdminBin -u$User -p$Password -h$Host  status 2>/dev/null  |cut -f9 -d":"`  
            echo $result| grep -v Warning  
        ;;  
         Slave_IO_State)  
            result=`if [ "$($MySQlBin -u$User -p$Password -h$Host  -e "show slave status\G" 2>/dev/null | grep Slave_IO_Running|awk '{print $2}')" == "Yes" ];then echo 1; else echo 0;fi 2>/dev/null `  
            echo $result| grep -v Warning  
        ;;  
         Slave_SQL_State)  
            result=`if [ "$($MySQlBin -u$User -p$Password -h$Host  -e "show slave status\G" 2>/dev/null | grep Slave_SQL_Running| grep -v _State |awk '{print $2}')" == "Yes" ];then echo 1; else echo 0;fi 2>/dev/null`  
            echo $result| grep -v Warning  
        ;;  
         Key_buffer_size)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'key_buffer_size';" 2>/dev/null | grep -v Value |awk '{print $2/1024^2}'`  
            echo $result| grep -v Warning  
        ;;  
         Key_reads)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'key_reads';" 2>/dev/null| grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Key_read_requests)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'key_read_requests';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Key_cache_miss_rate)  
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'key_reads';" 2>/dev/null | grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'key_read_requests';" 2>/dev/null | grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`  
            echo $result| grep -v Warning  
        ;;  
         Key_blocks_used)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'key_blocks_used';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Key_blocks_unused)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'key_blocks_unused';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Key_blocks_used_rate)  
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'key_blocks_used';" 2>/dev/null | grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'key_blocks_unused';"| grep -v Value |awk '{print $2}')| awk '{if(($1==0) && ($2==0))printf("%1.4f\n",0);else printf("%1.4f\n",$1/($1+$2)*100);}'`  
            echo $result| grep -v Warning  
        ;;  
         Innodb_buffer_pool_size)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'innodb_buffer_pool_size';" 2>/dev/null | grep -v Value |awk '{print $2/1024^2}'`  
            echo $result| grep -v Warning  
        ;;  
         Innodb_log_file_size)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'innodb_log_file_size';" 2>/dev/null | grep -v Value |awk '{print $2/1024^2}'`  
            echo $result| grep -v Warning  
        ;;  
         Innodb_log_buffer_size)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'innodb_log_buffer_size';" 2>/dev/null | grep -v Value |awk '{print $2/1024^2}'`  
            echo $result| grep -v Warning  
        ;;  
         Table_open_cache)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'table_open_cache';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Open_tables)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'open_tables';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Opened_tables)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'opened_tables';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Open_tables_rate)  
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'open_tables';" 2>/dev/null | grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'opened_tables';"| grep -v Value |awk '{print $2}')| awk '{if(($1==0) && ($2==0))printf("%1.4f\n",0);else printf("%1.4f\n",$1/($1+$2)*100);}'`  
            echo $result| grep -v Warning  
        ;;  
         Table_open_cache_used_rate)  
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'open_tables';" 2>/dev/null | grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'table_open_cache';"| grep -v Value |awk '{print $2}')| awk '{if(($1==0) && ($2==0))printf("%1.4f\n",0);else printf("%1.4f\n",$1/($1+$2)*100);}'`  
            echo $result| grep -v Warning  
        ;;  
         Thread_cache_size)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'thread_cache_size';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Threads_cached)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Threads_cached';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Threads_connected)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Threads_connected';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Threads_created)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Threads_created';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Threads_running)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Threads_running';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Qcache_free_blocks)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_free_blocks';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Qcache_free_memory)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_free_memory';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Qcache_hits)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_hits';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Qcache_inserts)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_inserts';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Qcache_lowmem_prunes)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_lowmem_prunes';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Qcache_not_cached)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_not_cached';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Qcache_queries_in_cache)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_queries_in_cache';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Qcache_total_blocks)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_total_blocks';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Qcache_fragment_rate)  
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_free_blocks';" 2>/dev/null | grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_total_blocks';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`  
            echo $result| grep -v Warning  
        ;;  
         Qcache_used_rate)  
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'query_cache_size';" 2>/dev/null | grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_free_memory';"| grep -v Value |awk '{print $2}')| awk '{if($1==0)printf("%1.4f\n",0);else printf("%1.4f\n",($1-$2)/$1*100);}'`  
            echo $result| grep -v Warning  
        ;;  
         Qcache_hits_rate)  
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_hits';" 2>/dev/null | grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Qcache_inserts';"| grep -v Value |awk '{print $2}')| awk '{if($1==0)printf("%1.4f\n",0);else printf("%1.4f\n",($1-$2)/$1*100);}'`  
            echo $result| grep -v Warning  
        ;;  
         Query_cache_limit)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'query_cache_limit';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Query_cache_min_res_unit)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'query_cache_min_res_unit';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Query_cache_size)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'query_cache_size';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Sort_merge_passes)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Sort_merge_passes';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Sort_range)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Sort_range';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Sort_rows)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Sort_rows';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Sort_scan)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Sort_scan';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Handler_read_first)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Handler_read_first';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Handler_read_key)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Handler_read_key';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Handler_read_next)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Handler_read_next';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Handler_read_prev)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Handler_read_prev';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Handler_read_rnd)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Handler_read_rnd';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Handler_read_rnd_next)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Handler_read_rnd_next';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Com_select)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'com_select';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Com_insert)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'com_insert';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Com_insert_select)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'com_insert_select';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Com_update)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'com_update';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Com_replace)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'com_replace';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Com_replace_select)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'com_replace_select';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Table_scan_rate)  
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Handler_read_rnd_next';" 2>/dev/null | grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'com_select';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`  
            echo $result| grep -v Warning  
        ;;  
         Open_files)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'open_files';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Open_files_limit)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'open_files_limit';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Open_files_rate)  
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'open_files';" 2>/dev/null | grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'open_files_limit';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`  
            echo $result| grep -v Warning  
        ;;  
         Created_tmp_disk_tables)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'created_tmp_disk_tables';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Created_tmp_tables)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'created_tmp_tables';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Created_tmp_disk_tables_rate)  
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'created_tmp_disk_tables';" 2>/dev/null | grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'created_tmp_tables';" 2>/dev/null | grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`  
            echo $result| grep -v Warning  
        ;;  
         Max_connections)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'max_connections';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Max_used_connections)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Max_used_connections';" 2>/dev/null | grep -v Value |awk '{print $2}'`  
            echo $result| grep -v Warning  
        ;;  
         Processlist)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show processlist" 2>/dev/null | grep -v "Id" | wc -l`  
            echo $result| grep -v Warning  
        ;;  
         Max_connections_used_rate)  
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Max_used_connections';" 2>/dev/null | grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'max_connections';"| grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%1.4f\n",$1/$2*100);}'`  
            echo $result| grep -v Warning  
        ;;  
        Connection_occupancy_rate)  
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Threads_connected';" 2>/dev/null | grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show variables like 'max_connections';" 2>/dev/null | grep -v Value |awk '{print $2}')| awk '{if($2==0)printf("%1.4f\n",0);else printf("%5.4f\n",$1/$2*100);}'`  
            echo $result| grep -v Warning  
        ;;  
  
         Table_locks_immediate)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Table_locks_immediate';" 2>/dev/null | grep -v Value |awk '{print $2}' 2>/dev/null `  
            echo $result| grep -v Warning  
        ;;  
         Table_locks_waited)  
            result=`$MySQlBin -u$User -p$Password -h$Host  -e "show status like 'table_locks_waited';" 2>/dev/null | grep -v Value |awk '{print $2}' 2>/dev/null `  
            echo $result| grep -v Warning  
        ;;  
         Engine_select)  
            result=`echo $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'Table_locks_immediate';" 2>/dev/null | grep -v Value |awk '{print $2}') $($MySQlBin -u$User -p$Password -h$Host  -e "show status like 'table_locks_waited';" 2>/dev/null | grep -v Value | awk '{print $2}') | awk '{if($2==0)printf("%1.4f\n",0);else printf("%5.4f\n",$1/$2*100);}' 2>/dev/null `  
            echo $result| grep -v Warning  
        ;;  
        *)  
           echo -e "\033[33mUsage: ./getmysqlinfo {Ping|Threads|Questions|Slowqueries|Qps|Slave_IO_State|Slave_SQL_State|Key_buffer_size|Key_reads|Key_read_requests|Key_cache_miss_rate|Key_blocks_used|Key_blocks_unused|Key_blocks_used_rate|Innodb_buffer_pool_size|Innodb_log_file_size|Innodb_log_buffer_size|Table_open_cache|Open_tables|Opened_tables|Open_tables_rate|Table_open_cache_used_rate|Thread_cache_size|Threads_cached|Threads_connected|Threads_created|Threads_running|Qcache_free_blocks|Qcache_free_memory|Qcache_hits|Qcache_inserts|Qcache_lowmem_prunes|Qcache_not_cached|Qcache_queries_in_cache|Qcache_total_blocks|Qcache_fragment_rate|Qcache_used_rate|Qcache_hits_rate|Query_cache_limit|Query_cache_min_res_unit|Query_cache_size|Sort_merge_passes|Sort_range|Sort_rows|Sort_scan|Handler_read_first|Handler_read_key|Handler_read_next|Handler_read_prev|Handler_read_rnd|Handler_read_rnd_next|Com_select|Com_insert|Com_insert_select|Com_update|Com_replace|Com_replace_select|Table_scan_rate|Open_files|Open_files_limit|Open_files_rate|Created_tmp_disk_tables|Created_tmp_tables|Created_tmp_disk_tables_rate|Max_connections|Max_used_connections|Processlist|Max_connections_used_rate|Table_locks_immediate|Table_locks_waited|Engine_select|Connection_occupancy_rate} \033[0m"  
  
        ;;  
    esac  
fi  
