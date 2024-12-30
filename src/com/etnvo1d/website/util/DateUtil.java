package com.etnvo1d.website.util;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class DateUtil {

    private static final String DATE_PATTERN = "yyyy-MM-dd";
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern(DATE_PATTERN);

    public static LocalDate stringToDate(String dateStr) {
        try {
            return LocalDate.parse(dateStr, formatter);
        } catch (Exception e) {
            throw new IllegalArgumentException("错误的日期格式，仅能转换yyyy-MM-dd");
        }
    }
    
    public static String dateToString(LocalDate date) {
        if (date == null) {
            return "";
        }
        return date.format(formatter);
    }

    private static final String DATETIME_PATTERN = "yyyy-MM-dd HH:mm:ss";
    private static final DateTimeFormatter datetimeFormatter = DateTimeFormatter.ofPattern(DATETIME_PATTERN);

    public static LocalDateTime stringToDateTime(String dateTimeStr) {
        try {
            return LocalDateTime.parse(dateTimeStr, datetimeFormatter);
        } catch (Exception e) {
            throw new IllegalArgumentException("错误的日期时间格式，仅能转换yyyy-MM-dd HH:mm:ss");
        }
    }

    public static String dateTimeToString(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "";
        }
        return dateTime.format(datetimeFormatter);
    }

    public static LocalDateTime localDateToDateTime(LocalDate date) {
        if (date == null) {
            return null;
        }
        return date.atStartOfDay();
    }
}