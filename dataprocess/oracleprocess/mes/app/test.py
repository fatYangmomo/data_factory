from dataprocess.oracleprocess.mes.app.lvlizhuisu import LvLi
from dataprocess.oracleprocess.mes.app.qiaojiao import QiaoJiao
from dataprocess.oracleprocess.mes.app.fee import Fee
from dataprocess.oracleprocess.mes.app.yunfantouru import YunFan
from dataprocess.oracleprocess.mes.app.cost import Cost
from dataprocess.oracleprocess.mes.app.erp核账 import HeZhang

import config as conf
from time import strftime,gmtime

def minx(data):
    def lcm(x, y):
        #  获取最小公倍数
        if x > y:
            greater = x
        else:
            greater = y
        while (True):
            if ((greater % x == 0) and (greater % y == 0)):
                lcm = greater
                break
            greater += 1
        return lcm
    res=int(data[0])
    for d in data[1:]:
        res=lcm(res,int(d))
    return res

def k2func(name,btime,etime):
    #履历追溯
    if 'lvlizhuisu'==name:
        print('执行：' + name)
        ll= LvLi()
        ll(btime, etime)
        del ll
    #翘角
    if 'qiaojiao'==name:
        print('执行：'+name)
        qj= QiaoJiao()
        qj(btime, etime)
        del qj
    #期间费用
    if 'fee'==name:
        print('执行：' + name)
        fee= Fee()
        fee()
        del fee
    #原反投入
    if 'yunfantouru'==name:
        print('执行：' + name)
        yf=YunFan()
        yf()
        del yf
    #损耗
    if 'cost'==name:
        print('执行：' + name)
        c=Cost()
        c()
        del c
    # erp核账
    if 'cost' == name:
        print('执行：' + name)
        hz = HeZhang()
        hz()
        del hz

def main():
    config = conf.configs
    lasttime=conf.total_T
    newpoint = strftime("%Y-%m-%d %H:%M:%S", gmtime())
    newpoint ="2017-07-01 00:00:00"
    for k,v in config.items():
        if int(v['T'])%lasttime==0:
            k2func(k,v['checkpoint'],newpoint)
            config[k]['checkpoint']=newpoint#修改checkpoint
    if lasttime == minx([v['T'] for v in config.values()]):
        new_T = 1  # 周期循环
    else:
        new_T = lasttime + 1
    with open ('config.py','w') as f:
        f.write(str(config)+'\n'+'total_T='+str(new_T))#写入配置文件
if __name__ == "__main__":
    main()