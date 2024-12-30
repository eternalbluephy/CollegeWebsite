package com.etnvo1d.website.dao;

import com.etnvo1d.website.entity.Bill;
import com.etnvo1d.website.entity.Rent;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class RentsDAO {
    public static List<Rent> queryRentByTimeRange(String userId, LocalDate startDate, LocalDate endDate, int page) {
        Connection con = ConnectionPool.getInstance().getConnection();
        List<Rent> rents = new ArrayList<>();
        try {
            PreparedStatement ps = con.prepareStatement(
                    "select id, name, time, state from rents where user_id=? and time between ? and ? order by id desc limit ?, 12"
            );
            ps.setString(1, userId);
            ps.setDate(2, java.sql.Date.valueOf(startDate));
            ps.setDate(3, java.sql.Date.valueOf(endDate));
            ps.setInt(4, (page - 1) * 12);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Rent rent = new Rent();
                rent.setId(rs.getInt("id"));
                rent.setName(rs.getString("name"));
                rent.setUserId(userId);
                rent.setTime(rs.getDate("time").toLocalDate());
                rent.setState(rs.getInt("state"));
                rents.add(rent);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return rents;
    }

    public static int countRentByTimeRange(String userId, LocalDate startDate, LocalDate endDate) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement(
                    "select count(*) as cnt from rents where user_id=? and time between ? and ?"
            );
            ps.setString(1, userId);
            ps.setDate(2, java.sql.Date.valueOf(startDate));
            ps.setDate(3, java.sql.Date.valueOf(endDate));
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

    public static int countRentByState(String userId, int type) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement(
                    "select count(*) as cnt from rents where user_id=? and state=?"
            );
            ps.setString(1, userId);
            ps.setInt(2, type);
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
