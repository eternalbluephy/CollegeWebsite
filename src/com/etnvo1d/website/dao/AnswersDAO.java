package com.etnvo1d.website.dao;

import com.etnvo1d.website.entity.Answer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AnswersDAO {
    public static int countAnswers(int id) {
        Connection con = ConnectionPool.getInstance().getConnection();
        int count = 0;
        try {
            PreparedStatement ps = con.prepareStatement(
                    "select count(*) as cnt from answers where question_id=?"
            );
            ps.setInt(1, id);
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

    public static List<Answer> queryAnswersByPage(int questionId, int page) {
        Connection con = ConnectionPool.getInstance().getConnection();
        List<Answer> answers = new ArrayList<>();
        try {
            PreparedStatement ps = con.prepareStatement(
                    "select a.id, a.author, a.content, a.time, u.name from answers a join users u on a.author=u.id where a.question_id=? order by id desc limit ?, 12"
            );
            ps.setInt(1, questionId);
            ps.setInt(2, (page - 1) * 12);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Answer answer = new Answer();
                answer.setId(rs.getInt("id"));
                answer.setAuthorId(rs.getString("author"));
                answer.setAuthorName(rs.getString("name"));
                answer.setContent(rs.getString("content"));
                answer.setTime(rs.getDate("time").toLocalDate());
                answers.add(answer);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
        return answers;
    }

    public static void insert(int questionId, String authorId, String content) {
        Connection con = ConnectionPool.getInstance().getConnection();
        try {
            PreparedStatement ps = con.prepareStatement("insert into answers (author, content, question_id, time) values (?, ?, ?, now())");
            ps.setString(1, authorId);
            ps.setString(2, content);
            ps.setInt(3, questionId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            ConnectionPool.getInstance().releaseConnection(con);
        }
    }
}
