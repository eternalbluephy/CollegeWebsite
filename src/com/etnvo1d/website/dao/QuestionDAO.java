package com.etnvo1d.website.dao;

import com.etnvo1d.website.entity.Question;
import com.etnvo1d.website.entity.Resource;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO {
    public static List<Question> queryQuestionHead(int count) {
        Connection con = ConnectionPool.getInstance().getConnection();
        List<Question> questionList = new ArrayList<>();
        try {
            PreparedStatement ps = con.prepareStatement(
                    "select q.id, q.title, q.author, q.time, u.name from questions q join users u on q.author = u.id order by q.time desc limit ?"
            );
            ps.setInt(1, count);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Question question = new Question();
                question.setId(rs.getInt("id"));
                question.setTitle(rs.getString("title"));
                question.setAuthorId(rs.getString("author"));
                question.setAuthorName(rs.getString("name"));
                question.setTime(rs.getDate("time").toLocalDate());
                questionList.add(question);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return questionList;
    }

    public static Question queryQuestion(int id) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement(
                    "select q.title, q.author, q.time, q.description, u.name from questions q join users u on q.author = u.id where q.id = ?"
            );
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Question question = new Question();
                question.setId(id);
                question.setTitle(rs.getString("title"));
                question.setDescription(rs.getString("description"));
                question.setAuthorId(rs.getString("author"));
                question.setAuthorName(rs.getString("name"));
                question.setTime(rs.getDate("time").toLocalDate());
                return question;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return null;
    }

    public static int countQuestions() {
        Connection con = ConnectionPool.getInstance().getConnection();
        int count = 0;
        try {
            PreparedStatement ps = con.prepareStatement(
                    "select count(*) as cnt from questions"
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

    public static List<Question> queryQuestionsByPage(int page) {
        Connection con = ConnectionPool.getInstance().getConnection();
        List<Question> questions = new ArrayList<>();
        try {
            PreparedStatement ps = con.prepareStatement(
                    "select q.id, q.title, q.author, q.time, u.name from questions q join users u on q.author = u.id order by q.id desc limit ?, 12"
            );
            ps.setInt(1, (page - 1) * 12);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Question question = new Question();
                question.setId(rs.getInt("id"));
                question.setTitle(rs.getString("title"));
                question.setAuthorId(rs.getString("author"));
                question.setTime(rs.getDate("time").toLocalDate());
                question.setAuthorName(rs.getString("name"));
                questions.add(question);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return questions;
    }

    public static void insert(String authorId, String title, String description) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement("insert into questions (author, title, description, time) values (?, ?, ?, now())");
            ps.setString(1, authorId);
            ps.setString(2, title);
            ps.setString(3, description);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
    }

}
