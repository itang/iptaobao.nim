discard """
  iptaobao:
  Nimrod wrapper for ip.taobao.com"
"""

import json, httpclient #, sockets

type
  TIpInfo* = tuple[countryId: string, country: string,
                   area: string, areaId: string,
                   region: string, regionId: string,
                   city: string, cityId: string,
                   isp: string, ispId: string, ip: string]

  TRet*    = tuple[ipInfo: TIpInfo, err: string]

const RestApiUrlPrefix* = "http://ip.taobao.com/service/getIpInfo.php?ip="

proc getIpInfo*(ip: string, timeout = 5000): TRet =
  try:
    let jcontent      = httpclient.getContent(RestApiUrlPrefix & ip,
                                              timeout = timeout).parseJson()
    let (code, jdata) = (jcontent["code"].num, jcontent["data"])
    if code == 0:
      result.ipInfo = (countryId: jdata["country_id"].str,
                       country:   jdata["country"].str,
                       area:      jdata["area"].str,
                       areaId:    jdata["area_id"].str,
                       region:    jdata["region"].str,
                       regionId:  jdata["region_id"].str,
                       city:      jdata["city"].str,
                       cityId:    jdata["city_id"].str,
                       isp:       jdata["isp"].str,
                       ispId:     jdata["isp_id"].str,
                       ip:        jdata["ip"].str)
    else:
      result.err = jdata.str
  except:
    let (e, msg) = (getCurrentException(), getCurrentExceptionMsg())
    result.err = "Got exception " & repr(e) & " with message " & msg

when isMainModule:
  for ip in ["888.888.888.888", "8.8.8.8"]:
    let (ipInfo, err) = getIpInfo(ip)
    if err != nil:
      echo "error: " & err
    else:
      echo "ok: " & $ipInfo
