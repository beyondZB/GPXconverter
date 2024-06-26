# GPX File Converter

这个脚本用于转换 GPX 文件的经纬度坐标。你可以提供一个目标经纬度，或者一个包含起点的 GPX 文件，脚本会将输入文件中的所有坐标偏移至目标位置。

## 使用方法

你可以使用以下两种方式运行这个脚本：

1. 提供目标经纬度：

    ```bash
    ./convertGpx.sh input.gpx target_start_lat target_start_lon
    ```

    在这种情况下，`target_start_lat` 和 `target_start_lon` 应该是有效的小数，表示起点目标位置的正确纬度和经度。

2. 提供一个包含起点的 GPX 文件：

    ```bash
    ./convertGpx.sh input.gpx start.gpx
    ```

    在这种情况下，脚本会从 `start.gpx` 文件中提取起点作为目标位置。

无论使用哪种方式，脚本都会创建一个新的 GPX 文件，其中的所有坐标都已经偏移至目标位置。新文件的名称格式为 `原文件名_fix.gpx`，并存放在 `fix` 目录下。

## 注意事项

- 这个脚本需要 `awk` 程序来运行。在大多数 Unix 和 Unix-like 系统中，`awk` 都是预装的。

- 这个脚本只处理包含 `<trkpt lat=` 标签的行。如果输入文件中的坐标使用了其他格式，那么这个脚本可能无法正确处理。

- 这个脚本在处理浮点数时使用了高精度计算，以避免精度丢失的问题。然而，由于计算机内部表示浮点数的方式，可能仍然存在微小的误差。
