package net.java_school.db.dbpool;

public class OracleConnectionManager extends ConnectionManager {

    public OracleConnectionManager() {
        super("oracle");
        String JDBCDriver = "oracle.jdbc.driver.OracleDriver";
        // 오라클용 JDBC thin driver
        String JDBCDriverType = "jdbc:oracle:thin";
        String url = JDBCDriverType + ":@" + dbServer + ":" + port + ":" + dbName;
        connMgr = DBConnectionPoolManager.getInstance();
        connMgr.init(poolName, JDBCDriver, url, userID, passwd, maxConn, initConn, maxWait);
    }
    
}