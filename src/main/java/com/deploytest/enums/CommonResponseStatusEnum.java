package com.deploytest.enums;

public enum CommonResponseStatusEnum {
    SUCCESS("success"),
    FAIL("fail");

    private final String status;

    CommonResponseStatusEnum(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }
}
