package com.deploytest.controller;

import com.deploytest.dto.CommonResponseDto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("/")
@RestController
public class HomeController {

    private final Logger logger = LoggerFactory.getLogger(HomeController.class);

    @GetMapping("")
    public ResponseEntity<CommonResponseDto<Void>> home() {
        logger.info("Request to Home");
        return ResponseEntity.ok(CommonResponseDto.success());
    }

    @GetMapping("health-check")
    public ResponseEntity<CommonResponseDto<Void>> healthCheck() {
        logger.info("Health Check");
        return ResponseEntity.ok(CommonResponseDto.success());
    }

    @PostMapping("/fail")
    public ResponseEntity<CommonResponseDto<Void>> fail() {
        logger.info("fail");
        return ResponseEntity.ok(CommonResponseDto.fail("fail"));
    }

    @GetMapping("exception")
    public ResponseEntity<CommonResponseDto<Void>> exception() {
        logger.info("exception");
        throw new IllegalStateException("exception");
    }


}
