/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package cadastro.model.util;

/**
 *
 * @author Alaim
 */

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

// Classe SequenceManager
public class SequenceManager {
    public static int getValue(String sequenceName) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int nextValue = -1;

        try {
            conn = ConectorBD.getConnection();
            stmt = conn.prepareStatement("SELECT NEXTVAL(?)");
            stmt.setString(1, sequenceName);
            rs = stmt.executeQuery();
            if (rs.next()) {
                nextValue = rs.getInt(1);
            }
        } finally {
            ConectorBD.close(rs);
            ConectorBD.close(stmt);
            ConectorBD.close(conn);
        }

        return nextValue;
    }
}


