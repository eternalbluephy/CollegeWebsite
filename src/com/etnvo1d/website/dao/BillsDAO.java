package com.etnvo1d.website.dao;

import com.etnvo1d.website.entity.Article;
import com.etnvo1d.website.entity.Bill;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BillsDAO {
    public static List<Bill> queryBillsByPage(String userId, int page) {
        Connection con = ConnectionPool.getInstance().getConnection();
        List<Bill> bills = new ArrayList<>();
        try {
            PreparedStatement ps = con.prepareStatement(
                    "select id, value, time from bills where user_id=? order by time desc limit ?, 12"
            );
            ps.setString(1, userId);
            ps.setInt(2, (page - 1) * 12);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setId(rs.getInt("id"));
                bill.setUserId(userId);
                bill.setValue(rs.getDouble("value"));
                bill.setTime(rs.getTimestamp("time").toLocalDateTime());
                bills.add(bill);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return bills;
    }

    public static List<Bill> queryBillsByTimeRange(String userId, LocalDateTime start, LocalDateTime end, int page) {
        Connection con = ConnectionPool.getInstance().getConnection();
        List<Bill> bills = new ArrayList<>();
        try {
            PreparedStatement ps = con.prepareStatement(
                "select id, value, time from bills where user_id=? and time between ? and ? order by time desc limit ?, 12"
            );
            ps.setString(1, userId);
            ps.setTimestamp(2, java.sql.Timestamp.valueOf(start));
            ps.setTimestamp(3, java.sql.Timestamp.valueOf(end));
            ps.setInt(4, (page - 1) * 12);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setId(rs.getInt("id"));
                bill.setUserId(userId);
                bill.setValue(rs.getDouble("value"));
                bill.setTime(rs.getTimestamp("time").toLocalDateTime());
                bills.add(bill);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return bills;
    }

    public static int countBills(String userId) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement(
                    "select count(*) as cnt from bills where user_id=?"
            );
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("cnt");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }  finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return 0;
    }

    public static int countBillsByTimeRange(String userId, LocalDateTime start, LocalDateTime end) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement(
                    "select count(*) as cnt from bills where user_id=? and time between ? and ?"
            );
            ps.setString(1, userId);
            ps.setTimestamp(2, java.sql.Timestamp.valueOf(start));
            ps.setTimestamp(3, java.sql.Timestamp.valueOf(end));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("cnt");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return 0;
    }
}
