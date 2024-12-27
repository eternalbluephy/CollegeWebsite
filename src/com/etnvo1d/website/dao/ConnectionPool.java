package com.etnvo1d.website.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ConnectionPool {
  private static final String URL = "jdbc:mysql://localhost:3306/college_website";
  private static final String USERNAME = "root";
  private static final String PASSWORD = "040708";
  private static final int INITIAL_POOL_SIZE = 5;
  private static final int MAX_POOL_SIZE = 10;

  private final List<Connection> connectionPool;
  private final List<Connection> usedConnections = new ArrayList<>();
  private static ConnectionPool instance = null;

  private ConnectionPool() {
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    }
    connectionPool = new ArrayList<>(INITIAL_POOL_SIZE);
    for (int i = 0; i < INITIAL_POOL_SIZE; i++) {
      connectionPool.add(createConnection());
    }
  }

  private Connection createConnection() {
    try {
      return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    } catch (SQLException e) {
      throw new RuntimeException("连接数据库失败", e);
    }
  }

  public static ConnectionPool getInstance() {
      if (instance == null) instance = new ConnectionPool();
      return instance;
  }

  public synchronized Connection getConnection() {
    if (connectionPool.isEmpty()) {
      if (usedConnections.size() < MAX_POOL_SIZE) {
        connectionPool.add(createConnection());
      } else {
        throw new RuntimeException("已达到连接池最大连接量");
      }
    }
    Connection connection = connectionPool.remove(connectionPool.size() - 1);
    usedConnections.add(connection);
    return connection;
  }

  public synchronized boolean releaseConnection(Connection connection) {
    connectionPool.add(connection);
    return usedConnections.remove(connection);
  }
}
