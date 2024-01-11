// 操作类

import {AGConnectCloudDB, CloudDBZoneConfig, CloudDBZoneQuery, CloudDBZoneObjectOperator} from "@agconnect/database-server/dist/index.js"
import {AGCClient, CredentialParser} from "@agconnect/common-server"
import path from 'path'
import {SmartAirConditioner} from "./SmartAirConditioner"

let object = new SmartAirConditioner();
// 修改为需要操作的对象
let objectName = object.getUserId;

let logger

let mCloudDBZone

class CloudDBZoneWrapper {

  // AGC & 数据库初始化
  constructor(log) {

    let agcClient;

    const credentialPath = "/resources/agc-apiclient-1262295477173397184-7287560032384444682.json";
    try {
      agcClient = AGCClient.getInstance();
    } catch (error) {
      AGCClient.initialize(CredentialParser.toCredential(path.join(__dirname, credentialPath)));
      agcClient = AGCClient.getInstance();
    }

    AGConnectCloudDB.initialize(agcClient)

    const cloudDBZoneConfig = new CloudDBZoneConfig("cloudDBZoneName1");

    const agconnectCloudDB = AGConnectCloudDB.getInstance(agcClient);
    mCloudDBZone = agconnectCloudDB.openCloudDBZone(cloudDBZoneConfig);
  }

  async selectByUserId(queryUserId) {

    if (!mCloudDBZone) {
      console.log("CloudDBClient is null, try re-initialize it")
      return;
    }
    try {
      console.log("CloudDBClient is OK")
      //
      const cloudDBZoneQuery = CloudDBZoneQuery.where(SmartAirConditioner);
      cloudDBZoneQuery.equalTo("userId", queryUserId);
      cloudDBZoneQuery.orderByAsc("deviceId");
      const resp = await mCloudDBZone.executeQuery(cloudDBZoneQuery);
      return resp.getSnapshotObjects();
    } catch (error) {
      console.log(error)
    }

  }

  async delete(data){
    if (!mCloudDBZone) {
      console.log("CloudDBClient is null, try re-initialize it");
      return;
    }
    try {
      const resp = await mCloudDBZone.executeDelete(data);
      return Boolean(resp);
    } catch (error) {
      console.warn('deleteBookInfos=>', error);
    }
  }

  // 插入数据
  async upsert(data) {
    if (!mCloudDBZone) {
      console.log("CloudDBClient is null, try re-initialize it");
      return;
    }
    try {
      const resp = await mCloudDBZone.executeUpsert(data);
      console.log("CloudDB Success")
      return Boolean(resp);
    } catch (error) {
      console.log("CloudDB error: " + error);
    }
  }

  async update(set, targetKey, newValue) {
    // set is the class instance to be updated
    if (!mCloudDBZone) {
      console.log("CloudDBClient is null, try re-initialize it");
      return;
    }

    try {
      console.log("updating")
      const operator = CloudDBZoneObjectOperator.build(set).update(targetKey, newValue);
      const updateNum = await mCloudDBZone.executeUpdate(operator);
      console.log("updateNum=>", updateNum);
      const updateOk = Boolean(updateNum);
      return updateOk;
    } catch (error) {
      console.warn('updateBookInfos=>', error);
    }
  }

}

export default CloudDBZoneWrapper;