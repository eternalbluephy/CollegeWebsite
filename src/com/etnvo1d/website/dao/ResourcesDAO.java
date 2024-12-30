package com.etnvo1d.website.dao;

import com.etnvo1d.website.entity.Article;
import com.etnvo1d.website.entity.Resource;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ResourcesDAO {
    public static List<Resource> queryResourcesByPage(int page) {
        Connection con = ConnectionPool.getInstance().getConnection();
        List<Resource> resources = new ArrayList<>();
        try {
            PreparedStatement ps = con.prepareStatement(
                    "select id, title, path, downloads, time from resources order by time desc limit ?, 12"
            );
            ps.setInt(1, (page - 1) * 12);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Resource resource = new Resource();
                resource.setId(rs.getInt("id"));
                resource.setTitle(rs.getString("title"));
                resource.setPath(rs.getString("path"));
                resource.setDownloads(rs.getInt("downloads"));
                resource.setTime(rs.getDate("time").toLocalDate());
                resources.add(resource);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return resources;
    }

    public static Resource queryResource(int id) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement(
                    "select title, path, downloads, time from resources where id=?"
            );
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Resource resource = new Resource();
                resource.setId(id);
                resource.setTitle(rs.getString("title"));
                resource.setPath(rs.getString("path"));
                resource.setDownloads(rs.getInt("downloads"));
                resource.setTime(rs.getDate("time").toLocalDate());
                return resource;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return null;
    }

    public static void remove(int id) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement("delete from resources where id=?");
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public static void update(int id, String title, String path) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement("update resources set title=?, path=? where id=?");
            ps.setString(1, title);
            ps.setString(2, path);
            ps.setInt(3, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
    }

    public static void update(int id, String title) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement("update resources set title=? where id=?");
            ps.setString(1, title);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
    }

    public static void insert(String title, String path) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement("insert into resources (title, path, downloads, time) values (?, ?, 0, now())");
            ps.setString(1, title);
            ps.setString(2, path);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
    }

    public static int countResources() {
        Connection con = ConnectionPool.getInstance().getConnection();
        int count = 0;
        try {
            PreparedStatement ps = con.prepareStatement(
                    "select count(*) as cnt from resources"
            );
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt("cnt");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return count;
    }

    public static void addDownloads(int id) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement("update resources set downloads=downloads+1 where id=?");
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
    }
}
