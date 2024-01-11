/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2020-2020. All rights reserved.
 * Generated by the CloudDB ObjectType compiler. DO NOT EDIT!
 */

class SmartCurtain {
    getFieldTypeMap() {
        let fieldTypeMap = new Map();
        fieldTypeMap.set('deviceId', 'IntAutoIncrement');
        fieldTypeMap.set('deviceName', 'String');
        fieldTypeMap.set('userId', 'String');
        fieldTypeMap.set('isOpened', 'Boolean');
        return fieldTypeMap;
    }

    getClassName() {
        return 'SmartCurtain';
    }

    getPrimaryKeyList() {
        let primaryKeyList = [];
        primaryKeyList.push('deviceId');
        return primaryKeyList;
    }

    getIndexList() {
        let indexList = [];
        indexList.push('userId');
        indexList.push('deviceName');
        return indexList;
    }

    getEncryptedFieldList() {
        let encryptedFieldList = [];
        return encryptedFieldList;
    }

    setDeviceId(deviceId) {
        this.deviceId = deviceId;
    }

    getDeviceId() {
        return this.deviceId;
    }

    setDeviceName(deviceName) {
        this.deviceName = deviceName;
    }

    getDeviceName() {
        return this.deviceName;
    }

    setUserId(userId) {
        this.userId = userId;
    }

    getUserId() {
        return this.userId;
    }

    setIsOpened(isOpened) {
        this.isOpened = isOpened;
    }

    getIsOpened() {
        return this.isOpened;
    }
}

module.exports = {SmartCurtain}