package com.dokki.user.config.exception;

import javax.servlet.ServletException;

public class LogoutException extends ServletException {
    public LogoutException(String msg){
        super(msg);
    }
}
