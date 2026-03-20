%% 生成一小时 (3600秒) 的高强度动态测试工况
clc; clear;

% 1. 生成时间轴 (0 到 3600 秒)
time_sec = (0:1:3600)';

% 2. 合成基础路况电流 (基础正弦波形 + 随机加减速波动)
% 模拟城市中走走停停，基础电流在 -1A 到 3A 之间震荡
I_base = 1.5 + 1.5 * sin(2*pi*time_sec/400) + 1.0 * sin(2*pi*time_sec/100) + randn(size(time_sec))*0.2;

% 3. 注入极端驾驶行为 (覆盖并挑战你的 2RC 极化模型)
I_dynamic = I_base;
I_dynamic(300:320)   = 5.5;   % 极速起步 (5.5A 大电流放电)
I_dynamic(800:815)   = -4.0;  % 紧急刹车触发能量回收 (4.0A 充电)
I_dynamic(1500:1540) = 4.8;   % 高速超车长放电
I_dynamic(2200:2210) = -3.5;  % 下坡持续能量回收
I_dynamic(3100:3150) = 6.0;   % 终点前全油门冲刺

% 4. 打包为 Simulink 标准信号源格式 (timeseries)
I_profile = timeseries(I_dynamic, time_sec);

disp('✅变量名：I_profile');