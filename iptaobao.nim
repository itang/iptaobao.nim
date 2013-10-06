discard """
  iptaobao:
  Nimrod wrapper for ip.taobao.com"
"""

import json, httpclient #, sockets

type
  TIpInfo* = tuple
    countryId: string
    country:   string
    area:      string
    areaId:    string
    region:    string
    regionId:  string
    city:      string
    cityId:    string
    isp:       string
    ispId:     string
    ip:        string

  TRet* = tuple[ipInfo: TIpInfo, err: string]

const RestApiUrlPrefix* = "http://ip.taobao.com/service/getIpInfo.php?ip="

proc getIpInfo*(ip: string, timeout = 5 * 1000): TRet =
  try:
    let
      url = RestApiUrlPrefix & ip
      content  = httpclient.getContent(url, timeout = timeout)
      jcontent = json.parseJson(content)
      data     = jcontent["data"]
      code     = jcontent["code"].num
    if code == 0:
      result.ipInfo = (countryId: data["country_id"].str,
                       country:   data["country"].str,
                       area:      data["area"].str,
                       areaId:    data["area_id"].str,
                       region:    data["region"].str,
                       regionId:  data["region_id"].str,
                       city:      data["city"].str,
                       cityId:    data["city_id"].str,
                       isp:       data["isp"].str,
                       ispId:     data["isp_id"].str,
                       ip:        data["ip"].str)
    else:
      result.err = data.str
  except:
    let
      e = getCurrentException()
      msg = getCurrentExceptionMsg()
    result.err = "Got exception " & repr(e) & " with message " & msg

when isMainModule:
  for ip in ["888.888.888.888", "8.8.8.8"]:
    let (ipInfo, err) = getIpInfo(ip)
    if err != nil:
      echo "error: " & err
    else:
      echo "ok: " & $ipInfo
