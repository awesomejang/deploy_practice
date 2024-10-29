package com.deploytest.dto;

import com.deploytest.enums.CommonResponseStatusEnum;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
public class CommonResponseDto<T> {
    private final T data;
    private final String message;
    private final CommonResponseStatusEnum status;
    private final LocalDateTime timeStamp;
    private String path = null;

    public CommonResponseDto(T data, String message, CommonResponseStatusEnum status, LocalDateTime now, String path) {
        this.data = data;
        this.message = message;
        this.status = status;
        this.timeStamp = now;
        this.path = path;
    }

    public static <T> CommonResponseDto<T> success() {
        return new CommonResponseDto<>(null, null, CommonResponseStatusEnum.SUCCESS, LocalDateTime.now(), null);
    }

    public static <T> CommonResponseDto<T> success(T data) {
        return new CommonResponseDto<>(data, null, CommonResponseStatusEnum.SUCCESS, LocalDateTime.now(), null);
    }

    public static <T> CommonResponseDto<T> success(T data, String message) {
        return new CommonResponseDto<>(data, message, CommonResponseStatusEnum.SUCCESS, LocalDateTime.now(), null);
    }

    public static <T> CommonResponseDto<T> fail(String message) {
        return new CommonResponseDto<>(null, message, CommonResponseStatusEnum.FAIL, LocalDateTime.now(), null);
    }

    public void changeRequestPath(String requestPath) {
        this.path = requestPath;
    }
}
