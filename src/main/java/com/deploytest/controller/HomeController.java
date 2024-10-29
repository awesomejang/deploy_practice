package com.deploytest.controller;

import com.deploytest.dto.CommonResponseDto;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("/")
@RestController
public class HomeController {

    @GetMapping("")
    public ResponseEntity<CommonResponseDto<Void>> home() {
        return ResponseEntity.ok(CommonResponseDto.success());
    }

    @GetMapping("health-check")
    public ResponseEntity<CommonResponseDto<Void>> healthCheck() {
        return ResponseEntity.ok(CommonResponseDto.success());
    }
}
