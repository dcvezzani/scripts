FasdUAS 1.101.10   ��   ��    k             l      ��  ��   
set response to display dialog "Which app windows to gather?" default answer "MacVim" with icon note buttons {"Continue", "Cancel"} default button "Continue"set targetAppName to (item 2 of (text of response))log targetAppNamelog (path to frontmost application as text)     � 	 	& 
 s e t   r e s p o n s e   t o   d i s p l a y   d i a l o g   " W h i c h   a p p   w i n d o w s   t o   g a t h e r ? "   d e f a u l t   a n s w e r   " M a c V i m "   w i t h   i c o n   n o t e   b u t t o n s   { " C o n t i n u e " ,   " C a n c e l " }   d e f a u l t   b u t t o n   " C o n t i n u e "   s e t   t a r g e t A p p N a m e   t o   ( i t e m   2   o f   ( t e x t   o f   r e s p o n s e ) )  l o g   t a r g e t A p p N a m e   l o g   ( p a t h   t o   f r o n t m o s t   a p p l i c a t i o n   a s   t e x t )    
  
 l   � ����  Q    �     k   �       l   ��������  ��  ��     ��  O   �    k   �       r        6      4   �� 
�� 
prcs  m   	 
����   =       n       !   1    ��
�� 
pisf !  g      m    ��
�� boovtrue  o      ���� $0 frontmostprocess frontmostProcess   " # " r     $ % $ m    ��
�� boovfals % n       & ' & 1    ��
�� 
pvis ' o    ���� $0 frontmostprocess frontmostProcess #  ( ) ( V    1 * + * I  ' ,�� ,��
�� .sysodelanull��� ��� nmbr , m   ' ( - - ?ə�������   + l  ! & .���� . =  ! & / 0 / n   ! $ 1 2 1 1   " $��
�� 
pisf 2 o   ! "���� $0 frontmostprocess frontmostProcess 0 m   $ %��
�� boovtrue��  ��   )  3 4 3 l  2 2��������  ��  ��   4  5 6 5 l  2 2�� 7 8��   7 Q K set activeApp to name of first application process whose frontmost is true    8 � 9 9 �   s e t   a c t i v e A p p   t o   n a m e   o f   f i r s t   a p p l i c a t i o n   p r o c e s s   w h o s e   f r o n t m o s t   i s   t r u e 6  : ; : r   2 C < = < 6 2 A > ? > n   2 8 @ A @ 1   6 8��
�� 
pnam A 4  2 6�� B
�� 
prcs B m   4 5����  ? =  9 @ C D C n   : < E F E 1   : <��
�� 
pisf F  g   : : D m   = ?��
�� boovtrue = o      ���� 0 	activeapp 	activeApp ;  G H G l  D D��������  ��  ��   H  I J I l   D D�� K L��   K + %			set activeApp to "Google Chrome"    L � M M J 	  	 	 s e t   a c t i v e A p p   t o   " G o o g l e   C h r o m e "  J  N O N I  D I�� P��
�� .ascrcmnt****      � **** P o   D E���� 0 	activeapp 	activeApp��   O  Q R Q l  J J��������  ��  ��   R  S T S l   J J�� U V��   U � �		set response to display dialog "Which app windows to gather?" default answer activeApp with icon note buttons {"Continue", "Cancel"} default button "Continue"	    V � W WF 	  	 s e t   r e s p o n s e   t o   d i s p l a y   d i a l o g   " W h i c h   a p p   w i n d o w s   t o   g a t h e r ? "   d e f a u l t   a n s w e r   a c t i v e A p p   w i t h   i c o n   n o t e   b u t t o n s   { " C o n t i n u e " ,   " C a n c e l " }   d e f a u l t   b u t t o n   " C o n t i n u e "  	 T  X Y X l  J J��������  ��  ��   Y  Z�� Z X   J� [�� \ [ Z   \� ] ^���� ] =  \ a _ ` _ n   \ _ a b a 1   ] _��
�� 
bkgo b o   \ ]���� 0 p   ` m   _ `��
�� boovfals ^ k   d� c c  d e d r   d i f g f n   d g h i h 1   e g��
�� 
pnam i o   d e���� 0 p   g o      ���� 0 appname appName e  j k j l  j j�� l m��   l   log appName    m � n n    l o g   a p p N a m e k  o p o l  j j�� q r��   q !  log (appName is activeApp)    r � s s 6   l o g   ( a p p N a m e   i s   a c t i v e A p p ) p  t u t l  j j��������  ��  ��   u  v�� v Z   j� w x���� w l  j m y���� y =  j m z { z o   j k���� 0 appname appName { o   k l���� 0 	activeapp 	activeApp��  ��   x k   p� | |  } ~ } I  p u�� ��
�� .ascrcmnt****      � ****  o   p q���� 0 appname appName��   ~  � � � l  v v��������  ��  ��   �  ��� � O  v� � � � O   z� � � � k   �� � �  � � � r   � � � � � I  � ��� ���
�� .corecnte****       **** � 2  � ���
�� 
cwin��   � o      ���� 0 
windowscnt 
windowsCnt �  � � � I  � ��� ���
�� .ascrcmnt****      � **** � o   � ����� 0 
windowscnt 
windowsCnt��   �  � � � l  � ���������  ��  ��   �  � � � l   � ��� � ���   � M G Google Chrome windows don't seem to have the right size/position info     � � � � �   G o o g l e   C h r o m e   w i n d o w s   d o n ' t   s e e m   t o   h a v e   t h e   r i g h t   s i z e / p o s i t i o n   i n f o   �  � � � Z   �, � ��� � � l  � � ����� � =  � � � � � o   � ����� 0 appname appName � m   � � � � � � �  G o o g l e   C h r o m e��  ��   � k   � � � �  � � � l  � ���������  ��  ��   �  � � � r   � � � � � J   � � � �  � � � m   � ������ �  ��� � m   � ��������   � o      ���� 0 
windowsize 
windowSize �  � � � r   � � � � � J   � � � �  � � � m   � ������w �  ��� � m   � ���������   � o      ����  0 windowposition windowPosition �  � � � r   � � � � � \   � � � � � l  � � ����� � n   � � � � � 4   � ��� �
�� 
cobj � m   � �����  � o   � ����� 0 
windowsize 
windowSize��  ��   � l  � � ����� � n   � � � � � 4   � ��� �
�� 
cobj � m   � �����  � o   � �����  0 windowposition windowPosition��  ��   � o      ���� 0 xdiff xDiff �  � � � r   � � � � � \   � � � � � l  � � ����� � n   � � � � � 4   � ��� �
�� 
cobj � m   � �����  � o   � ����� 0 
windowsize 
windowSize��  ��   � l  � � ����� � n   � � � � � 4   � ��� �
�� 
cobj � m   � �����  � o   � �����  0 windowposition windowPosition��  ��   � o      ���� 0 ydiff yDiff �  ��� � l  � ���������  ��  ��  ��  ��   � k   �, � �  � � � r   � � � � � n   � � � � � 1   � ��
� 
ptsz � 4   � ��~ �
�~ 
cwin � m   � ��}�}  � o      �|�| 0 
windowsize 
windowSize �  � � � r   � � � � n   � � � � 1   ��{
�{ 
posn � 4   � ��z �
�z 
cwin � m   � ��y�y  � o      �x�x  0 windowposition windowPosition �  � � � r   � � � \   � � � l  ��w�v � n   � � � 4  
�u �
�u 
cobj � m  �t�t  � o  
�s�s 0 
windowsize 
windowSize�w  �v   � l  ��r�q � n   � � � 4  �p �
�p 
cobj � m  �o�o  � o  �n�n  0 windowposition windowPosition�r  �q   � o      �m�m 0 xdiff xDiff �  � � � r  * � � � \  & � � � l  ��l�k � n   � � � 4  �j �
�j 
cobj � m  �i�i  � o  �h�h 0 
windowsize 
windowSize�l  �k   � l % ��g�f � n  % � � � 4  "%�e �
�e 
cobj � m  #$�d�d  � o  "�c�c  0 windowposition windowPosition�g  �f   � o      �b�b 0 ydiff yDiff �  ��a � l ++�`�_�^�`  �_  �^  �a   �  � � � l --�]�\�[�]  �\  �[   �  �  � I -A�Z�Y
�Z .ascrcmnt****      � **** J  -=  o  -0�X�X 0 
windowsize 
windowSize  o  03�W�W  0 windowposition windowPosition  o  36�V�V 0 xdiff xDiff 	�U	 o  69�T�T 0 ydiff yDiff�U  �Y    

 l BB�S�R�Q�S  �R  �Q    r  BI m  BE�P�P  o      �O�O "0 windowoffsetinc windowOffsetInc  r  J] ]  JY l JU�N�M \  JU l JS�L�K I JS�J�I
�J .corecnte****       **** 2 JO�H
�H 
cwin�I  �L  �K   m  ST�G�G �N  �M   o  UX�F�F "0 windowoffsetinc windowOffsetInc o      �E�E 0 windowoffset windowOffset  l ^^�D�C�B�D  �C  �B    Y  ^��A !�@ k  p�"" #$# r  p�%&% J  p�'' ()( [  pz*+* l pv,�?�>, n  pv-.- 4  sv�=/
�= 
cobj/ m  tu�<�< . o  ps�;�;  0 windowposition windowPosition�?  �>  + l vy0�:�90 o  vy�8�8 0 windowoffset windowOffset�:  �9  ) 1�71 [  z�232 l z�4�6�54 n  z�565 4  }��47
�4 
cobj7 m  ~�3�3 6 o  z}�2�2  0 windowposition windowPosition�6  �5  3 l ��8�1�08 o  ���/�/ 0 windowoffset windowOffset�1  �0  �7  & o      �.�. &0 newwindowposition newWindowPosition$ 9:9 l ���-;<�-  ; ; 5 log {newWindowSize, newWindowPosition, xDiff, yDiff}   < �== j   l o g   { n e w W i n d o w S i z e ,   n e w W i n d o w P o s i t i o n ,   x D i f f ,   y D i f f }: >?> l ���,�+�*�,  �+  �*  ? @A@ r  ��BCB o  ���)�) &0 newwindowposition newWindowPositionC n      DED 1  ���(
�( 
posnE 4  ���'F
�' 
cwinF o  ���&�& 0 w  A GHG r  ��IJI o  ���%�% 0 
windowsize 
windowSizeJ n      KLK 1  ���$
�$ 
ptszL 4  ���#M
�# 
cwinM o  ���"�" 0 w  H N�!N r  ��OPO \  ��QRQ o  ��� �  0 windowoffset windowOffsetR o  ���� "0 windowoffsetinc windowOffsetIncP o      �� 0 windowoffset windowOffset�!  �A 0 w    m  ab�� ! l bkS��S I bk�T�
� .corecnte****       ****T 2 bg�
� 
cwin�  �  �  �@   UVU l ������  �  �  V W�W l ������  �  �  �   � 4   z ��X
� 
pcapX l  ~ �Y��Y c   ~ �Z[Z n   ~ �\]\ 1    ��
� 
pnam] o   ~ �� 0 p  [ m   � ��
� 
TEXT�  �   � m   v w^^�                                                                                  sevs  alis    \  Macintosh HD                   BD ����System Events.app                                              ����            ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  ��  ��  ��  ��  ��  ��  �� 0 p   \ 2   M P�

�
 
prcs��    m    __�                                                                                  sevs  alis    \  Macintosh HD                   BD ����System Events.app                                              ����            ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  ��    R      �	`a
�	 .ascrerr ****      � ****` m      �
� 
clina �b�
� 
errnb o      �� 0 num  �    l ���cd�  c 3 - display dialog "Error on line number " & num   d �ee Z   d i s p l a y   d i a l o g   " E r r o r   o n   l i n e   n u m b e r   "   &   n u m��  ��    f�f l     ��� �  �  �   �       ��gh��  g ��
�� .aevtoappnull  �   � ****h ��i����jk��
�� .aevtoappnull  �   � ****i k    �ll  
����  ��  ��  j �������� 0 p  �� 0 w  �� 0 num  k &_��m������ -�������������������������� ���������������������������������n
�� 
prcsm  
�� 
pisf�� $0 frontmostprocess frontmostProcess
�� 
pvis
�� .sysodelanull��� ��� nmbr
�� 
pnam�� 0 	activeapp 	activeApp
�� .ascrcmnt****      � ****
�� 
kocl
�� 
cobj
�� .corecnte****       ****
�� 
bkgo�� 0 appname appName
�� 
pcap
�� 
TEXT
�� 
cwin�� 0 
windowscnt 
windowsCnt�������� 0 
windowsize 
windowSize���w������  0 windowposition windowPosition�� 0 xdiff xDiff�� 0 ydiff yDiff
�� 
ptsz
�� 
posn�� �� �� "0 windowoffsetinc windowOffsetInc�� 0 windowoffset windowOffset�� &0 newwindowposition newWindowPosition
�� 
clinn ������
�� 
errn�� 0 num  ��  ������*�k/�[�,\Ze81E�Of��,FO h��,e �j [OY��O*�k/�,�[�,\Ze81E�O�j 
O*�-[��l kh  ��,f b��,E�O�� R�j 
O�D*a ��,a &/4*a -j E` O_ j 
O�a   Da a lvE` Oa a lvE` O_ �k/_ �k/E` O_ �l/_ �l/E` OPY E*a k/a ,E` O*a k/a ,E` O_ �k/_ �k/E` O_ �l/_ �l/E` OPO_ _ _ _ a vj 
Oa  E` !O*a -j k_ ! E` "O Zk*a -j kh _ �k/_ "_ �l/_ "lvE` #O_ #*a �/a ,FO_ *a �/a ,FO_ "_ !E` "[OY��OPUUY hY h[OY��UW X $ %hascr  ��ޭ