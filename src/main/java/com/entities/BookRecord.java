package com.entities;

import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class BookRecord {
    public Book book;
    public Date startDate;
    public Date endDate;
    public enum ReportStatus { NONE, DAMAGED, LOST }
    public ReportStatus reportStatus = ReportStatus.NONE;

    // 逾期计算逻辑（不存储为字段）
    public int getOverdueDays() {
        if (endDate == null) return 0;

        LocalDate dueDate = endDate.toLocalDate();
        LocalDate today = LocalDate.now();

        if (today.isAfter(dueDate)) {
            return (int) ChronoUnit.DAYS.between(dueDate, today);
        }
        return 0;
    }

    public double calculateFine() {
        int overdueDays = getOverdueDays();
        if (overdueDays > 0 && book != null) {
            // 每天罚金为图书价格的1%
            return book.price * 0.01 * overdueDays;
        }
        return 0.0;
    }
}
