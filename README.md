iptaobao.nim
============

Nimrod wrapper for ip.taobao.com.


### Install

    $ git clone https://github.com/itang/iptaobao.nim.git
    $ cd iptaobao.nim
    $ babel install

### Usage

    import iptaobao

    let (ipInfo, err) = getIpInfo("8.8.8.8")

    echo($ipInfo)
    # output: (countryId: US, country: 美国, area: , areaId: , region: , regionId: , city: , cityId: , isp: , ispId: , ip: 8.8.8.8)
