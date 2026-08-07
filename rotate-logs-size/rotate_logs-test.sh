#!/bin/bash


#echo "$SIZE - $LIMIT"
#read -p "в каком городе вы хотите погоду?:" NAME
#echo "погода: $NAME "
#LOG_FILE="/var/log/auth.log"
#echo "$SIZE ../"
#echo "$(ls $LOG_FILE)"
#echo "\nОтчет успешно сохранен в $LOG_FILE"

LOG_FILE="$1"
SIZE_LIMIT="$2"

if [ "$#" -lt 2 ]; then
	echo "Usage: $0 <path_to_log_file> <max_size_mb>"
	exit 1
fi
 
if [ ! -f "$LOG_FILE" ]; then
	echo "[ERROR] Log file $LOG_FILE does not exist."
	exit 1
fi

#touch app.log
#cp app.log app.log
DATE=$(date "+%Y-%m-%d_%H:%M:%S")
#SIZE=$(du -s "$LOG_FILE" | cut -f1)
SIZE=$(du -m "$LOG_FILE" | awk '{print $1}')
echo "$SIZE"
if [ "$SIZE" -lt "$SIZE_LIMIT" ]; then
	echo -e "[INFO] Log size is OK ($SIZE MB / $SIZE_LIMIT MB)"
	exit 0
fi

APP_LOG="${LOG_FILE}.${DATE}"
cp "$LOG_FILE" "$APP_LOG" && > "$LOG_FILE"
echo "[INFO] Размер лога превышен ($SIZE MB / $SIZE_LIMIT MB). Начинаю ротацию ..."
echo "[INFO] Ротация завершена: $(basename "${APP_LOG}.gz") создан"
gzip "$APP_LOG" && echo "Ротация Успешно создана"
## basename ${APP_LOG}.gz"
echo "${APP_LOG}.gz путь файла"

#touch app.log app.log.$DATE 
#cp app.log app.log.$DATE
#gzip app.log.$DATE
