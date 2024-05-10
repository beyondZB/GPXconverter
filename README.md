# 目标
修正 garmin connect 或 strava 下载的路书gpx文件，在国内地图上的偏移。

# 方法
从行者路书画一段起点开始的路书，下载 gpx 文件 从而获取起点正确经纬度用于纠偏。

# 实现
./convertGpx.sh 脚本，利用 awk 进行经纬度数据识别，纠偏，替换。

#指令格式
./convertGpx.sh ./xx.gpx [targetLat] [targetLon]

targetLat 和 targetLon 为起点的正确经纬度，可从行者路书画一段起点开始的路书，下载 gpx文件获取。
若不输入 targetLat 和 targetLon ，则以默认偏移修正，非常容易有误差。