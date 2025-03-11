function [sqnr] =  perf_fixed_SQNR(float_point_data, fixed_point_data, Q_num)
% 计算定点化后数据误差SQNR

    fix2float = reshape(double(float_point_data/(2^Q_num)),1,[]);
    float = reshape(fixed_point_data,1,[]);
    
    sqnr = 10*log10(sum(abs(float).^2)/sum(abs(float-fix2float).^2));
end

