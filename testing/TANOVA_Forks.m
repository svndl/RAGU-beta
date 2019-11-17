
       Variable combo                                      callback       efs index       callback input                   callback output 
   
default                                             --> @OLES      (1, 1, t)        currSample                          noBL_M

DoF1 & ~contF1                                      --> @OLES      (1, 2, t)        noBL_M                              mmBLF1
DoF2                                                --> @OLES      (1, 3, t)        noBL_M                              mmBLF2
DoF1 & DoF2                                         --> @OLES      (1, 4, t)        noBL_M - mmBLF1 - mmBLF2            mmBLGF1F2
DoF1 & contF1                                       --> @OLESC     (1, 2, t)        noBL_M                              mmBLF1

DoGroup & ContGroup                                 --> @OLESCG    (2, 1, t)        noBL_M                              noBL_MG
DoGroup & ~ContGroup                                --> @OLESG     (2, 1, t)        noBL_M                              noBL_MG 

(DoF1 & contF1) & (DoGroup & ContGroup)             --> @OLESCCG   (2, 2, t)        noBL_MG - mmBLF1                    mmBLGF1
(DoF1 & contF1) & (DoGroup & ~ContGroup)            --> @OLESGDC   (2, 2, t)        noBL_MG - mmBLF1                    mmBLGF1

(DoF1 & ~contF1) & (DoGroup & ContGroup)            --> @OLESCG    (2, 2, t)        noBL_MG - mmBLF1                    mmBLGF1
(DoF1 & ~contF1) & (DoGroup & ~ContGroup)           --> @OLESG     (2, 2, t)        noBL_MG - mmBLF1                    mmBLGF1

DoF2 & (DoGroup & ContGroup)                        --> @OLESCG    (2, 3, t)        noBL_MG - mmBLF2                    mmBLGF2
DoF2 & (DoGroup & ~ContGroup)                       --> @OLESG     (2, 3, t)        noBL_MG - mmBLF2                    mmBLGF2

(DoF1 & DoF2) & (DoGroup & ContGroup)               --> @OLESCG    (2, 4, t)        noBL_MG - mmBLF1 - mmBLF2 - mmBLGF1 - mmBLGF2 - mmBLGF1F2
(DoF1 & DoF2) & (DoGroup & ~ContGroup)              --> @OLESG     (2, 4, t)        noBL_MG - mmBLF1 - mmBLF2 - mmBLGF1 - mmBLGF2 - mmBLGF1F2



new fork:

if DoFactors (F1 or F2 and ~Groups)
    
    DoF1 & ~contF1                                      --> @OLES      (1, 2, t)        noBL_M                              mmBLF1
    DoF2                                                --> @OLES      (1, 3, t)        noBL_M                              mmBLF2
    DoF1 & DoF2                                         --> @OLES      (1, 4, t)        noBL_M - mmBLF1 - mmBLF2            mmBLGF1F2
    DoF1 & contF1                                       --> @OLESC     (1, 2, t)        noBL_M                              mmBLF1
    
if DoGroups (Groups & ~(F1 & F2) )
    DoGroup & ContGroup                                 --> @OLESCG    (2, 1, t)        noBL_M                              noBL_MG
    DoGroup & ~ContGroup                                --> @OLESG     (2, 1, t)        noBL_M                              noBL_MG
    
if DoGroupsFactors
    
    (DoF1 & contF1) & (DoGroup & ContGroup)             --> @OLESCCG   (2, 2, t)        noBL_MG - mmBLF1                    mmBLGF1
    (DoF1 & contF1) & (DoGroup & ~ContGroup)            --> @OLESGDC   (2, 2, t)        noBL_MG - mmBLF1                    mmBLGF1

    (DoF1 & ~contF1) & (DoGroup & ContGroup)            --> @OLESCG    (2, 2, t)        noBL_MG - mmBLF1                    mmBLGF1
    (DoF1 & ~contF1) & (DoGroup & ~ContGroup)           --> @OLESG     (2, 2, t)        noBL_MG - mmBLF1                    mmBLGF1

    DoF2 & (DoGroup & ContGroup)                        --> @OLESCG    (2, 3, t)        noBL_MG - mmBLF2                    mmBLGF2
    DoF2 & (DoGroup & ~ContGroup)                       --> @OLESG     (2, 3, t)        noBL_MG - mmBLF2                    mmBLGF2

    (DoF1 & DoF2) & (DoGroup & ContGroup)               --> @OLESCG    (2, 4, t)        noBL_MG - mmBLF1 - mmBLF2 - mmBLGF1 - mmBLGF2 - mmBLGF1F2
    (DoF1 & DoF2) & (DoGroup & ~ContGroup)              --> @OLESG     (2, 4, t)        noBL_MG - mmBLF1 - mmBLF2 - mmBLGF1 - mmBLGF2 - mmBLGF1F2

    