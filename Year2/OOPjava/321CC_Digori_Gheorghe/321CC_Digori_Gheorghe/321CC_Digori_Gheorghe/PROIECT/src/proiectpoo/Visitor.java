/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package proiectpoo;

/**
 *
 * @author gelud
 */
interface Visitor {
    void visit(BookDepartment bookDepartment);
    void visit(MusicDepartment musicDepartment);
    void visit(SoftwareDepartment softwareDepartment);
    void visit(VideoDepartment videoDepartment);

}
