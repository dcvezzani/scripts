FasdUAS 1.101.10   ��   ��    k             l     ��  ��    ` Z Source: http://www.jonathanlaliberte.com/2007/10/19/move-all-windows-to-your-main-screen/     � 	 	 �   S o u r c e :   h t t p : / / w w w . j o n a t h a n l a l i b e r t e . c o m / 2 0 0 7 / 1 0 / 1 9 / m o v e - a l l - w i n d o w s - t o - y o u r - m a i n - s c r e e n /   
  
 l     ��  ��    I C and: http://www.macosxhints.com/article.php?story=2007102012424539     �   �   a n d :   h t t p : / / w w w . m a c o s x h i n t s . c o m / a r t i c l e . p h p ? s t o r y = 2 0 0 7 1 0 2 0 1 2 4 2 4 5 3 9      l     ��������  ��  ��        l     ��  ��      Improvements:     �      I m p r o v e m e n t s :      l     ��  ��    5 / +  code is more efficient and more elegant now     �   ^   +     c o d e   i s   m o r e   e f f i c i e n t   a n d   m o r e   e l e g a n t   n o w      l     ��  ��    L F + windows are moved also, if they are "almost" completely off-screen      �   �   +   w i n d o w s   a r e   m o v e d   a l s o ,   i f   t h e y   a r e   " a l m o s t "   c o m p l e t e l y   o f f - s c r e e n       !   l     �� " #��   " _ Y      (in the orig. version, they would be moved only if they were completely off-screen)    # � $ $ �             ( i n   t h e   o r i g .   v e r s i o n ,   t h e y   w o u l d   b e   m o v e d   o n l y   i f   t h e y   w e r e   c o m p l e t e l y   o f f - s c r e e n ) !  % & % l     �� ' (��   ' R L + windows are moved (if they are moved) to their closest position on-screen    ( � ) ) �   +   w i n d o w s   a r e   m o v e d   ( i f   t h e y   a r e   m o v e d )   t o   t h e i r   c l o s e s t   p o s i t i o n   o n - s c r e e n &  * + * l     �� , -��   , S M     (in the orig. version, they would be moved to a "home position" (0,22) )    - � . . �           ( i n   t h e   o r i g .   v e r s i o n ,   t h e y   w o u l d   b e   m o v e d   t o   a   " h o m e   p o s i t i o n "   ( 0 , 2 2 )   ) +  / 0 / l     �� 1 2��   1 !  Gabriel Zachmann, Jan 2008    2 � 3 3 6   G a b r i e l   Z a c h m a n n ,   J a n   2 0 0 8 0  4 5 4 l     ��������  ��  ��   5  6 7 6 l     �� 8 9��   8 [ U Example list of processes to ignore: {"xGestures"} or {"xGestures", "OtherApp", ...}    9 � : : �   E x a m p l e   l i s t   o f   p r o c e s s e s   t o   i g n o r e :   { " x G e s t u r e s " }   o r   { " x G e s t u r e s " ,   " O t h e r A p p " ,   . . . } 7  ; < ; j     �� =�� &0 processestoignore processesToIgnore = J      > >  ?�� ? m      @ @ � A A  T y p i n a t o r��   <  B C B l     ��������  ��  ��   C  D E D l     �� F G��   F J D Get the size of the Display(s), only useful if there is one display    G � H H �   G e t   t h e   s i z e   o f   t h e   D i s p l a y ( s ) ,   o n l y   u s e f u l   i f   t h e r e   i s   o n e   d i s p l a y E  I J I l     �� K L��   K = 7 otherwise it will grab the total size of both displays    L � M M n   o t h e r w i s e   i t   w i l l   g r a b   t h e   t o t a l   s i z e   o f   b o t h   d i s p l a y s J  N O N l     P���� P O      Q R Q k     S S  T U T r     V W V n     X Y X 1   	 ��
�� 
pbnd Y n    	 Z [ Z m    	��
�� 
cwin [ 1    ��
�� 
desk W o      ���� 0 _b   U  \ ] \ r     ^ _ ^ n     ` a ` 4    �� b
�� 
cobj b m    ����  a o    ���� 0 _b   _ o      ���� 0 screen_width   ]  c�� c r     d e d n     f g f 4    �� h
�� 
cobj h m    ����  g o    ���� 0 _b   e o      ���� 0 screen_height  ��   R m      i i�                                                                                  MACS  alis    @  Macintosh HD                   BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p    M a c i n t o s h   H D  &System/Library/CoreServices/Finder.app  / ��  ��  ��   O  j k j l     ��������  ��  ��   k  l m l l   � n���� n O    � o p o k   ! � q q  r s r r   ! $ t u t m   ! "������ u o      ���� 0 min_xpos   s  v w v r   % * x y x 2  % (��
�� 
pcap y o      ���� 0 allprocesses allProcesses w  z�� z Y   + � {�� | }�� { k   9 � ~ ~   �  l  9 9�� � ���   � 4 .display dialog (name of (process i)) as string    � � � � \ d i s p l a y   d i a l o g   ( n a m e   o f   ( p r o c e s s   i ) )   a s   s t r i n g �  ��� � Z   9 � � ����� � H   9 L � � l  9 K ����� � E   9 K � � � o   9 >���� &0 processestoignore processesToIgnore � l  > J ����� � c   > J � � � l  > F ����� � n   > F � � � 1   B F��
�� 
pnam � l  > B ����� � 4   > B�� �
�� 
prcs � o   @ A���� 0 i  ��  ��  ��  ��   � m   F I��
�� 
TEXT��  ��  ��  ��   � Q   O � � ��� � O   R � � � � k   Y � � �  � � � Y   Y � ��� � ��� � k   i � � �  � � � r   i u � � � n   i q � � � 1   m q��
�� 
posn � 4   i m�� �
�� 
cwin � o   k l���� 0 x   � o      ���� 0 winpos winPos �  � � � r   v � � � � n   v | � � � 4   y |�� �
�� 
cobj � m   z {����  � o   v y���� 0 winpos winPos � o      ���� 0 _x   �  � � � r   � � � � � n   � � � � � 4   � ��� �
�� 
cobj � m   � �����  � o   � ����� 0 winpos winPos � o      ���� 0 _y   �  � � � r   � � � � � n   � � � � � 1   � ���
�� 
ptsz � 4   � ��� �
�� 
cwin � o   � ����� 0 x   � o      ���� 0 winsize winSize �  � � � r   � � � � � n   � � � � � 4   � ��� �
�� 
cobj � m   � �����  � o   � ����� 0 winsize winSize � o      ���� 0 _w   �  � � � r   � � � � � n   � � � � � 4   � ��� �
�� 
cobj � m   � �����  � o   � ����� 0 winsize winSize � o      ���� 0 _h   �  � � � l  � ��� � ���   � d ^display dialog (name as string) & " - width: " & (_w as string) & " height: " & (_h as string)    � � � � � d i s p l a y   d i a l o g   ( n a m e   a s   s t r i n g )   &   "   -   w i d t h :   "   &   ( _ w   a s   s t r i n g )   &   "   h e i g h t :   "   &   ( _ h   a s   s t r i n g ) �  ��� � Z   � � � ����� � l  � � ����� � A   � � � � � o   � ����� 0 _x   � o   � ����� 0 min_xpos  ��  ��   � k   � � � �  � � � l  � ��� � ���   � ) #set _x to _x + (_w + _x + min_xpos)    � � � � F s e t   _ x   t o   _ x   +   ( _ w   +   _ x   +   m i n _ x p o s ) �  � � � r   � � � � � m   � ������ � o      ���� 0 _x   �  ��� � r   � � � � � J   � � � �  � � � o   � ����� 0 _x   �  ��� � o   � ����� 0 _y  ��   � n       � � � 1   � ���
�� 
posn � 4   � ��� �
�� 
cwin � o   � ����� 0 x  ��  ��  ��  ��  �� 0 x   � m   \ ]����  � l  ] d ����� � I  ] d�� ���
�� .corecnte****       **** � 2  ] `��
�� 
cwin��  ��  ��  ��   �  ��� � l  � ���������  ��  ��  ��   � 4   R V�� �
�� 
prcs � o   T U���� 0 i   � R      ������
�� .ascrerr ****      � ****��  ��  ��  ��  ��  ��  �� 0 i   | m   . /��  } I  / 4�~ ��}
�~ .corecnte****       **** � o   / 0�|�| 0 allprocesses allProcesses�}  ��  ��   p m     � ��                                                                                  sevs  alis    \  Macintosh HD                   BD ����System Events.app                                              ����            ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  ��  ��   m  � � � l     �{�z�y�{  �z  �y   �  � � � l     �x�w�v�x  �w  �v   �  � � � l      �u � ��u   �
set response to display dialog "Which app windows to gather?" default answer "MacVim" with icon note buttons {"Continue", "Cancel"} default button "Continue"set targetAppName to (item 2 of (text of response))log targetAppNamelog (path to frontmost application as text)    � � � �& 
 s e t   r e s p o n s e   t o   d i s p l a y   d i a l o g   " W h i c h   a p p   w i n d o w s   t o   g a t h e r ? "   d e f a u l t   a n s w e r   " M a c V i m "   w i t h   i c o n   n o t e   b u t t o n s   { " C o n t i n u e " ,   " C a n c e l " }   d e f a u l t   b u t t o n   " C o n t i n u e "   s e t   t a r g e t A p p N a m e   t o   ( i t e m   2   o f   ( t e x t   o f   r e s p o n s e ) )  l o g   t a r g e t A p p N a m e   l o g   ( p a t h   t o   f r o n t m o s t   a p p l i c a t i o n   a s   t e x t )  �  � � � l     �t�s�r�t  �s  �r   �  � � � i    � � � I      �q ��p�q 0 getval getVal �  � � � o      �o�o 0 thelist theList �  ��n � o      �m�m 0 thekey theKey�n  �p   � k     (    X     %�l Z     �k�j l   �i�h =    	 n    

 1    �g
�g 
kMsg o    �f�f 0 theitem theItem	 o    �e�e 0 thekey theKey�i  �h   k      L     o    �d�d 0 theitem theItem �c  S    �c  �k  �j  �l 0 theitem theItem o    �b�b 0 thelist theList �a L   & ( m   & '�`
�` 
null�a   �  l     �_�^�]�_  �^  �]    i  	  I      �\�[�\ 0 getkeys getKeys �Z o      �Y�Y 0 thelist theList�Z  �[   k     /  r      J     �X�X   o      �W�W 0 responselist responseList  !  X    ,"�V#" Z    '$%�U�T$ l   &�S�R& >   '(' n    )*) 1    �Q
�Q 
kMsg* o    �P�P 0 theitem theItem( m    ++ �,,  d o n e�S  �R  % r    #-.- l    /�O�N/ n     010 1     �M
�M 
kMsg1 o    �L�L 0 theitem theItem�O  �N  . l     2�K�J2 n      343  ;   ! "4 o     !�I�I 0 responselist responseList�K  �J  �U  �T  �V 0 theitem theItem# o    	�H�H 0 thelist theList! 5�G5 L   - /66 o   - .�F�F 0 responselist responseList�G   787 l     �E�D�C�E  �D  �C  8 9:9 i   ;<; I      �B=�A�B 0 setwin setWin= >?> o      �@�@ 0 win  ? @A@ o      �?�? 0 x  A BCB o      �>�> 0 y  C DED o      �=�= 0 xpos  E F�<F o      �;�; 0 ypos  �<  �A  < k     GG HIH r     JKJ J     LL MNM o     �:�: 0 xpos  N O�9O o    �8�8 0 ypos  �9  K o      �7�7  0 windowposition windowPositionI PQP r    RSR J    TT UVU o    �6�6 0 x  V W�5W o    	�4�4 0 y  �5  S o      �3�3 0 
windowsize 
windowSizeQ XYX r    Z[Z o    �2�2  0 windowposition windowPosition[ n      \]\ o    �1�1 0 position  ] o    �0�0 0 win  Y ^�/^ r    _`_ o    �.�. 0 
windowsize 
windowSize` n      aba 1    �-
�- 
ptszb o    �,�, 0 win  �/  : cdc l     �+�*�)�+  �*  �)  d efe i   ghg I      �(i�'�( 0 getwin getWini jkj o      �&�& 0 win  k lml o      �%�% 0 x  m non o      �$�$ 0 y  o pqp o      �#�# 0 xpos  q r�"r o      �!�! 0 ypos  �"  �'  h k     ss tut r     vwv J     xx yzy o     � �  0 xpos  z {�{ o    �� 0 ypos  �  w o      ��  0 windowposition windowPositionu |}| r    ~~ J    �� ��� o    �� 0 x  � ��� o    	�� 0 y  �   o      �� 0 
windowsize 
windowSize} ��� L    �� J    �� ��� o    �� 0 
windowsize 
windowSize� ��� o    ��  0 windowposition windowPosition�  �  f ��� l     ����  �  �  � ��� l      ����  �UO
set myWindows to {
{key: "Mail", x: 840, y: 513, xpos: 5760, ypos: 82},
{key: "Skype for Business", x: 840, y: 513, xpos: 5760, ypos: 596},
{key: "Messages", x: 840, y: 513, xpos: 6600, ypos: 596},
{key: "Teams", x: 840, y: 513, xpos: 6600, ypos: 82},
{key: "Google Chrome", x: 2000, y: 1000, xpos: 3500, ypos: -300},
{key: "done"}
}
   � ���� 
 s e t   m y W i n d o w s   t o   { 
 { k e y :   " M a i l " ,   x :   8 4 0 ,   y :   5 1 3 ,   x p o s :   5 7 6 0 ,   y p o s :   8 2 } , 
 { k e y :   " S k y p e   f o r   B u s i n e s s " ,   x :   8 4 0 ,   y :   5 1 3 ,   x p o s :   5 7 6 0 ,   y p o s :   5 9 6 } , 
 { k e y :   " M e s s a g e s " ,   x :   8 4 0 ,   y :   5 1 3 ,   x p o s :   6 6 0 0 ,   y p o s :   5 9 6 } , 
 { k e y :   " T e a m s " ,   x :   8 4 0 ,   y :   5 1 3 ,   x p o s :   6 6 0 0 ,   y p o s :   8 2 } , 
 { k e y :   " G o o g l e   C h r o m e " ,   x :   2 0 0 0 ,   y :   1 0 0 0 ,   x p o s :   3 5 0 0 ,   y p o s :   - 3 0 0 } , 
 { k e y :   " d o n e " } 
 } 
� ��� l     ����  �  �  � ��� l  ������ r   ����� J   ���� ��� K   ��� ���
� 
kMsg� m   � ��� ���  C a l e n d a r� �
���
 0 x  � m   � ��	�	M� ���� 0 y  � m   ���� ���� 0 xpos  � m  ���p� ���� 0 ypos  � m  ����  � ��� K  4�� ���
� 
kMsg� m  �� ���  M a i l� � ���  0 x  � m  ����H� ������ 0 y  � m  !$����� ������ 0 xpos  � m  '*�����p� ������� 0 ypos  � m  -0���� ���  � ��� K  4V�� ����
�� 
kMsg� m  7:�� ���  M e s s a g e s� ������ 0 x  � m  =@����H� ������ 0 y  � m  CF����� ������ 0 xpos  � m  IL������� ������� 0 ypos  � m  OR�������  � ��� K  Vx�� ����
�� 
kMsg� m  Y\�� ��� 
 T e a m s� ������ 0 x  � m  _b����H� ������ 0 y  � m  eh����� ������ 0 xpos  � m  kn������� ������� 0 ypos  � m  qt���� 5��  � ���� K  x��� �����
�� 
kMsg� m  {~�� ���  d o n e��  ��  � o      ���� 0 	mywindows 	myWindows�  �  � ��� l     ������  � %  300, 0, 6630, 112, -6330, -112   � ��� >   3 0 0 ,   0 ,   6 6 3 0 ,   1 1 2 ,   - 6 3 3 0 ,   - 1 1 2� ��� l     ������  � ' ! x:840, y:513, xpos:6600, ypos:82   � ��� B   x : 8 4 0 ,   y : 5 1 3 ,   x p o s : 6 6 0 0 ,   y p o s : 8 2� ��� l     ������  � D > {key:"Google Chrome", x:2000, y:1000, xpos:3500, ypos:-300},    � ��� |   { k e y : " G o o g l e   C h r o m e " ,   x : 2 0 0 0 ,   y : 1 0 0 0 ,   x p o s : 3 5 0 0 ,   y p o s : - 3 0 0 } ,  � ��� l     ��������  ��  ��  � ��� l     ������  � m g set supportedApps to {"Mail", "Skype for Business", "Messages", "MacVim", "Google Chrome", "Calendar"}   � ��� �   s e t   s u p p o r t e d A p p s   t o   { " M a i l " ,   " S k y p e   f o r   B u s i n e s s " ,   " M e s s a g e s " ,   " M a c V i m " ,   " G o o g l e   C h r o m e " ,   " C a l e n d a r " }� ��� l �������� r  ����� l �������� n ����� I  ��������� 0 getkeys getKeys� ���� o  ������ 0 	mywindows 	myWindows��  ��  �  f  ����  ��  � o      ���� 0 supportedapps supportedApps��  ��  � ��� l     ������  �   log supportedApps   � ��� $   l o g   s u p p o r t e d A p p s� ��� l �������� r  ����� m  ����
�� boovfals� o      ���� &0 showwindowdetails showWindowDetails��  ��  �    l     ��������  ��  ��    l ������ Q  �� k  �} 	
	 O  �{ k  �z  Z  �e���� o  ������ &0 showwindowdetails showWindowDetails X  �a�� Z  �\���� = �� n  �� 1  ����
�� 
bkgo o  ������ 0 p   m  ����
�� boovfals k  �X  r  �� n  ��  1  ����
�� 
pnam  o  ������ 0 p   o      ���� 0 appname appName !"! r  ��#$# I ����%��
�� .corecnte****       ****% 2 ����
�� 
cwin��  $ o      ���� 0 
windowscnt 
windowsCnt" &'& l ����������  ��  ��  ' ()( l ����*+��  *   log appName   + �,,    l o g   a p p N a m e) -��- O �X./. O  �W010 k  �V22 343 r  ��565 I ����7��
�� .corecnte****       ****7 2 ����
�� 
cwin��  6 o      ���� 0 
windowscnt 
windowsCnt4 898 r  �:;: n  �<=< 1   ��
�� 
ptsz= 4  � ��>
�� 
cwin> m  ������ ; o      ���� 0 
windowsize 
windowSize9 ?@? r  	ABA n  	CDC 1  ��
�� 
posnD 4  	��E
�� 
cwinE m  ���� B o      ����  0 windowposition windowPosition@ FGF r  'HIH \  #JKJ l L����L n  MNM 4  ��O
�� 
cobjO m  ���� N o  ���� 0 
windowsize 
windowSize��  ��  K l "P����P n  "QRQ 4  "��S
�� 
cobjS m   !���� R o  ����  0 windowposition windowPosition��  ��  I o      ���� 0 xdiff xDiffG TUT r  (9VWV \  (5XYX l (.Z����Z n  (.[\[ 4  +.��]
�� 
cobj] m  ,-���� \ o  (+���� 0 
windowsize 
windowSize��  ��  Y l .4^����^ n  .4_`_ 4  14��a
�� 
cobja m  23���� ` o  .1����  0 windowposition windowPosition��  ��  W o      ���� 0 ydiff yDiffU bcb l ::��������  ��  ��  c ded I :T��f��
�� .ascrcmnt****      � ****f J  :Pgg hih m  :=jj �kk  w i n d o w I n f oi lml o  =@���� 0 appname appNamem non o  @C���� 0 
windowsize 
windowSizeo pqp o  CF����  0 windowposition windowPositionq rsr o  FI���� 0 xdiff xDiffs t��t o  IL���� 0 ydiff yDiff��  ��  e u��u l UU��������  ��  ��  ��  1 4  ���v
� 
pcapv l ��w�~�}w c  ��xyx n  ��z{z 1  ���|
�| 
pnam{ o  ���{�{ 0 p  y m  ���z
�z 
TEXT�~  �}  / m  ��||�                                                                                  sevs  alis    \  Macintosh HD                   BD ����System Events.app                                              ����            ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  ��  ��  ��  �� 0 p   2  ���y
�y 
prcs��  ��   }~} l ff�x�w�v�x  �w  �v  ~ � X  fx��u�� Z  zs���t�s� = z���� n  z��� 1  {�r
�r 
bkgo� o  z{�q�q 0 p  � m  ��p
�p boovfals� k  �o�� ��� r  ����� n  ����� 1  ���o
�o 
pnam� o  ���n�n 0 p  � o      �m�m 0 appname appName� ��l� Z  �o���k�j� E  ����� o  ���i�i 0 supportedapps supportedApps� o  ���h�h 0 appname appName� k  �k�� ��� r  ����� I ���g��f
�g .corecnte****       ****� 2 ���e
�e 
cwin�f  � o      �d�d 0 
windowscnt 
windowsCnt� ��� r  ����� l ����c�b� n ����� I  ���a��`�a 0 getval getVal� ��� o  ���_�_ 0 	mywindows 	myWindows� ��^� o  ���]�] 0 appname appName�^  �`  �  f  ���c  �b  � o      �\�\ 0 windowdetails windowDetails� ��� l ���[�Z�Y�[  �Z  �Y  � ��X� O �k��� O  �j��� k  �i�� ��� r  ����� I ���W��V
�W .corecnte****       ****� 2 ���U
�U 
cwin�V  � o      �T�T 0 
windowscnt 
windowsCnt� ��� r  ����� m  ���S�S � o      �R�R "0 windowoffsetinc windowOffsetInc� ��� r  ����� ]  ����� l ����Q�P� \  ����� l ����O�N� I ���M��L
�M .corecnte****       ****� 2 ���K
�K 
cwin�L  �O  �N  � m  ���J�J �Q  �P  � o  ���I�I "0 windowoffsetinc windowOffsetInc� o      �H�H 0 windowoffset windowOffset� ��� l ���G�F�E�G  �F  �E  � ��� Y  �g��D���C� Z  �b���B�A� > ���� o  � �@�@ 0 windowdetails windowDetails� m   �?
�? 
null� k  ^�� ��� r  #��� J  �� ��� [  ��� l ��>�=� n  ��� o  
�<�< 0 xpos  � o  
�;�; 0 windowdetails windowDetails�>  �=  � o  �:�: 0 windowoffset windowOffset� ��9� [  ��� l ��8�7� n  ��� o  �6�6 0 ypos  � o  �5�5 0 windowdetails windowDetails�8  �7  � o  �4�4 0 windowoffset windowOffset�9  � o      �3�3  0 windowposition windowPosition� ��� r  $8��� J  $4�� ��� n  $+��� o  '+�2�2 0 x  � o  $'�1�1 0 windowdetails windowDetails� ��0� n  +2��� o  .2�/�/ 0 y  � o  +.�.�. 0 windowdetails windowDetails�0  � o      �-�- 0 
windowsize 
windowSize� ��� r  9E��� o  9<�,�,  0 windowposition windowPosition� n      ��� 1  @D�+
�+ 
posn� 4  <@�*�
�* 
cwin� o  >?�)�) 0 w  � ��� r  FR��� o  FI�(�( 0 
windowsize 
windowSize� n      ��� 1  MQ�'
�' 
ptsz� 4  IM�&�
�& 
cwin� o  KL�%�% 0 w  � ��$� r  S^��� \  SZ��� o  SV�#�# 0 windowoffset windowOffset� o  VY�"�" "0 windowoffsetinc windowOffsetInc� o      �!�! 0 windowoffset windowOffset�$  �B  �A  �D 0 w  � m  ��� �  � l ������ I ��� �
� .corecnte****       ****  2 ���
� 
cwin�  �  �  �C  � � l hh����  �  �  �  � 4  ���
� 
pcap l ���� c  �� n  �� 1  ���
� 
pnam o  ���� 0 p   m  ���
� 
TEXT�  �  � m  ���                                                                                  sevs  alis    \  Macintosh HD                   BD ����System Events.app                                              ����            ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  �X  �k  �j  �l  �t  �s  �u 0 p  � 2  il�
� 
prcs� 	
	 l yy����  �  �  
  l  yy��  ��
	repeat with p in every process		if background only of p is false then			set appName to name of p			-- log appName			-- log (appName is activeApp)						log appName						try				tell application "System Events" to tell application process (name of p as string)					set windowsCnt to count of windows					-- log windowsCnt										set windowSize to size of window 1					set windowPosition to position of window 1					set xDiff to (item 1 of windowSize) - (item 1 of windowPosition)					set yDiff to (item 2 of windowSize) - (item 2 of windowPosition)										-- log {"windowInfo", appName, windowSize, windowPosition, xDiff, yDiff}				end tell			on error line number num				-- display dialog "Error on line number " & num			end try		end if	end repeat		repeat with p in every process		try			if background only of p is false then				set appName to name of p				set windowDetails to (my getVal(myWindows, appName))								tell application "System Events" to tell application process (name of p as string)					set windowsCnt to count of windows										set windowOffsetInc to 30					set windowOffset to ((count of windows) - 1) * windowOffsetInc										repeat with w from 1 to (count of windows)												if windowDetails is not null then							set windowPosition to {(xpos of windowDetails) + windowOffset, (ypos of windowDetails) + windowOffset}							set windowSize to {x of windowDetails, y of windowDetails}							set position of window w to windowPosition							set size of window w to windowSize							set windowOffset to windowOffset - windowOffsetInc						end if					end repeat									end tell			end if		on error line number num			display dialog (get properties of p)		end try	end repeat
	    �� 
 	 r e p e a t   w i t h   p   i n   e v e r y   p r o c e s s  	 	 i f   b a c k g r o u n d   o n l y   o f   p   i s   f a l s e   t h e n  	 	 	 s e t   a p p N a m e   t o   n a m e   o f   p  	 	 	 - -   l o g   a p p N a m e  	 	 	 - -   l o g   ( a p p N a m e   i s   a c t i v e A p p )  	 	 	  	 	 	 l o g   a p p N a m e  	 	 	  	 	 	 t r y  	 	 	 	 t e l l   a p p l i c a t i o n   " S y s t e m   E v e n t s "   t o   t e l l   a p p l i c a t i o n   p r o c e s s   ( n a m e   o f   p   a s   s t r i n g )  	 	 	 	 	 s e t   w i n d o w s C n t   t o   c o u n t   o f   w i n d o w s  	 	 	 	 	 - -   l o g   w i n d o w s C n t  	 	 	 	 	  	 	 	 	 	 s e t   w i n d o w S i z e   t o   s i z e   o f   w i n d o w   1  	 	 	 	 	 s e t   w i n d o w P o s i t i o n   t o   p o s i t i o n   o f   w i n d o w   1  	 	 	 	 	 s e t   x D i f f   t o   ( i t e m   1   o f   w i n d o w S i z e )   -   ( i t e m   1   o f   w i n d o w P o s i t i o n )  	 	 	 	 	 s e t   y D i f f   t o   ( i t e m   2   o f   w i n d o w S i z e )   -   ( i t e m   2   o f   w i n d o w P o s i t i o n )  	 	 	 	 	  	 	 	 	 	 - -   l o g   { " w i n d o w I n f o " ,   a p p N a m e ,   w i n d o w S i z e ,   w i n d o w P o s i t i o n ,   x D i f f ,   y D i f f }  	 	 	 	 e n d   t e l l  	 	 	 o n   e r r o r   l i n e   n u m b e r   n u m  	 	 	 	 - -   d i s p l a y   d i a l o g   " E r r o r   o n   l i n e   n u m b e r   "   &   n u m  	 	 	 e n d   t r y  	 	 e n d   i f  	 e n d   r e p e a t  	  	 r e p e a t   w i t h   p   i n   e v e r y   p r o c e s s  	 	 t r y  	 	 	 i f   b a c k g r o u n d   o n l y   o f   p   i s   f a l s e   t h e n  	 	 	 	 s e t   a p p N a m e   t o   n a m e   o f   p  	 	 	 	 s e t   w i n d o w D e t a i l s   t o   ( m y   g e t V a l ( m y W i n d o w s ,   a p p N a m e ) )  	 	 	 	  	 	 	 	 t e l l   a p p l i c a t i o n   " S y s t e m   E v e n t s "   t o   t e l l   a p p l i c a t i o n   p r o c e s s   ( n a m e   o f   p   a s   s t r i n g )  	 	 	 	 	 s e t   w i n d o w s C n t   t o   c o u n t   o f   w i n d o w s  	 	 	 	 	  	 	 	 	 	 s e t   w i n d o w O f f s e t I n c   t o   3 0  	 	 	 	 	 s e t   w i n d o w O f f s e t   t o   ( ( c o u n t   o f   w i n d o w s )   -   1 )   *   w i n d o w O f f s e t I n c  	 	 	 	 	  	 	 	 	 	 r e p e a t   w i t h   w   f r o m   1   t o   ( c o u n t   o f   w i n d o w s )  	 	 	 	 	 	  	 	 	 	 	 	 i f   w i n d o w D e t a i l s   i s   n o t   n u l l   t h e n  	 	 	 	 	 	 	 s e t   w i n d o w P o s i t i o n   t o   { ( x p o s   o f   w i n d o w D e t a i l s )   +   w i n d o w O f f s e t ,   ( y p o s   o f   w i n d o w D e t a i l s )   +   w i n d o w O f f s e t }  	 	 	 	 	 	 	 s e t   w i n d o w S i z e   t o   { x   o f   w i n d o w D e t a i l s ,   y   o f   w i n d o w D e t a i l s }  	 	 	 	 	 	 	 s e t   p o s i t i o n   o f   w i n d o w   w   t o   w i n d o w P o s i t i o n  	 	 	 	 	 	 	 s e t   s i z e   o f   w i n d o w   w   t o   w i n d o w S i z e  	 	 	 	 	 	 	 s e t   w i n d o w O f f s e t   t o   w i n d o w O f f s e t   -   w i n d o w O f f s e t I n c  	 	 	 	 	 	 e n d   i f  	 	 	 	 	 e n d   r e p e a t  	 	 	 	 	  	 	 	 	 e n d   t e l l  	 	 	 e n d   i f  	 	 o n   e r r o r   l i n e   n u m b e r   n u m  	 	 	 d i s p l a y   d i a l o g   ( g e t   p r o p e r t i e s   o f   p )  	 	 e n d   t r y  	 e n d   r e p e a t 
 	 � l yy�
�	��
  �	  �  �   m  ���                                                                                  sevs  alis    \  Macintosh HD                   BD ����System Events.app                                              ����            ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  
 � l ||����  �  �  �   R      �
� .ascrerr ****      � **** m      �
� 
clin �� 
� 
errn o      ���� 0 num  �    l ������   3 - display dialog "Error on line number " & num    � Z   d i s p l a y   d i a l o g   " E r r o r   o n   l i n e   n u m b e r   "   &   n u m��  ��    l     ��������  ��  ��    l      ����  
set response to display dialog "Which app windows to gather?" default answer "MacVim" with icon note buttons {"Continue", "Cancel"} default button "Continue"set targetAppName to (item 2 of (text of response))log targetAppNamelog (path to frontmost application as text)    �& 
 s e t   r e s p o n s e   t o   d i s p l a y   d i a l o g   " W h i c h   a p p   w i n d o w s   t o   g a t h e r ? "   d e f a u l t   a n s w e r   " M a c V i m "   w i t h   i c o n   n o t e   b u t t o n s   { " C o n t i n u e " ,   " C a n c e l " }   d e f a u l t   b u t t o n   " C o n t i n u e "   s e t   t a r g e t A p p N a m e   t o   ( i t e m   2   o f   ( t e x t   o f   r e s p o n s e ) )  l o g   t a r g e t A p p N a m e   l o g   ( p a t h   t o   f r o n t m o s t   a p p l i c a t i o n   a s   t e x t )   !  l �u"����" Q  �u#$%# k  �l&& '(' l ����������  ��  ��  ( )��) O  �l*+* k  �k,, -.- r  ��/0/ 6��121 4 ����3
�� 
prcs3 m  ������ 2 = ��454 n  ��676 1  ����
�� 
pisf7  g  ��5 m  ����
�� boovtrue0 o      ���� $0 frontmostprocess frontmostProcess. 898 r  ��:;: m  ����
�� boovfals; n      <=< 1  ����
�� 
pvis= o  ������ $0 frontmostprocess frontmostProcess9 >?> V  ��@A@ I ����B��
�� .sysodelanull��� ��� nmbrB m  ��CC ?ə�������  A l ��D����D = ��EFE n  ��GHG 1  ����
�� 
pisfH o  ������ $0 frontmostprocess frontmostProcessF m  ����
�� boovtrue��  ��  ? IJI l ����������  ��  ��  J KLK l ����MN��  M Q K set activeApp to name of first application process whose frontmost is true   N �OO �   s e t   a c t i v e A p p   t o   n a m e   o f   f i r s t   a p p l i c a t i o n   p r o c e s s   w h o s e   f r o n t m o s t   i s   t r u eL PQP r  ��RSR 6��TUT n  ��VWV 1  ����
�� 
pnamW 4 ����X
�� 
prcsX m  ������ U = ��YZY n  ��[\[ 1  ����
�� 
pisf\  g  ��Z m  ����
�� boovtrueS o      ���� 0 	activeapp 	activeAppQ ]^] l ����������  ��  ��  ^ _`_ l  ����ab��  a + %			set activeApp to "Google Chrome"   b �cc J 	  	 	 s e t   a c t i v e A p p   t o   " G o o g l e   C h r o m e " ` ded I ����f��
�� .ascrcmnt****      � ****f o  ������ 0 	activeapp 	activeApp��  e ghg l ����������  ��  ��  h iji l  ����kl��  k � �		set response to display dialog "Which app windows to gather?" default answer activeApp with icon note buttons {"Continue", "Cancel"} default button "Continue"	   l �mmF 	  	 s e t   r e s p o n s e   t o   d i s p l a y   d i a l o g   " W h i c h   a p p   w i n d o w s   t o   g a t h e r ? "   d e f a u l t   a n s w e r   a c t i v e A p p   w i t h   i c o n   n o t e   b u t t o n s   { " C o n t i n u e " ,   " C a n c e l " }   d e f a u l t   b u t t o n   " C o n t i n u e "  	j non l ����������  ��  ��  o p��p X  �kq��rq Z  �fst����s = �uvu n  �wxw 1   ��
�� 
bkgox o  � ���� 0 p  v m  ��
�� boovfalst k  	byy z{z r  	|}| n  	~~ 1  
��
�� 
pnam o  	
���� 0 p  } o      ���� 0 appname appName{ ��� l ������  �   log appName   � ���    l o g   a p p N a m e� ��� l ������  � !  log (appName is activeApp)   � ��� 6   l o g   ( a p p N a m e   i s   a c t i v e A p p )� ��� l ��������  ��  ��  � ���� Z  b������� l ������ = ��� o  ���� 0 appname appName� o  ���� 0 	activeapp 	activeApp��  ��  � k  ^�� ��� I $�����
�� .ascrcmnt****      � ****� o   ���� 0 appname appName��  � ��� l %%��������  ��  ��  � ���� O %^��� O  )]��� k  8\�� ��� r  8C��� I 8?�����
�� .corecnte****       ****� 2 8;��
�� 
cwin��  � o      ���� 0 
windowscnt 
windowsCnt� ��� I DK�����
�� .ascrcmnt****      � ****� o  DG���� 0 
windowscnt 
windowsCnt��  � ��� l LL��������  ��  ��  � ��� l  LL������  � M G Google Chrome windows don't seem to have the right size/position info    � ��� �   G o o g l e   C h r o m e   w i n d o w s   d o n ' t   s e e m   t o   h a v e   t h e   r i g h t   s i z e / p o s i t i o n   i n f o  � ��� Z  L������� l LS������ = LS��� o  LO���� 0 appname appName� m  OR�� ���  G o o g l e   C h r o m e��  ��  � k  V��� ��� r  Vb��� J  V^�� ��� m  VY������ ���� m  Y\�������  � o      ���� 0 
windowsize 
windowSize� ��� r  co��� J  ck�� ��� m  cf�����w� ���� m  fi��������  � o      ����  0 windowposition windowPosition� ��� r  p���� \  p}��� l pv������ n  pv��� 4  sv���
�� 
cobj� m  tu���� � o  ps���� 0 
windowsize 
windowSize��  ��  � l v|������ n  v|��� 4  y|���
�� 
cobj� m  z{���� � o  vy����  0 windowposition windowPosition��  ��  � o      ���� 0 xdiff xDiff� ��� r  ����� \  ����� l �������� n  ����� 4  �����
�� 
cobj� m  ������ � o  ������ 0 
windowsize 
windowSize��  ��  � l �������� n  ����� 4  �����
�� 
cobj� m  ������ � o  ������  0 windowposition windowPosition��  ��  � o      ���� 0 ydiff yDiff� ���� l ���������  ��  �  ��  ��  � k  ���� ��� r  ����� n  ����� 1  ���~
�~ 
ptsz� 4  ���}�
�} 
cwin� m  ���|�| � o      �{�{ 0 
windowsize 
windowSize� ��� r  ����� n  ����� 1  ���z
�z 
posn� 4  ���y�
�y 
cwin� m  ���x�x � o      �w�w  0 windowposition windowPosition� ��� r  ����� \  ����� l ����v�u� n  ����� 4  ���t�
�t 
cobj� m  ���s�s � o  ���r�r 0 
windowsize 
windowSize�v  �u  � l ����q�p� n  ��� � 4  ���o
�o 
cobj m  ���n�n   o  ���m�m  0 windowposition windowPosition�q  �p  � o      �l�l 0 xdiff xDiff�  r  �� \  �� l ���k�j n  ��	
	 4  ���i
�i 
cobj m  ���h�h 
 o  ���g�g 0 
windowsize 
windowSize�k  �j   l ���f�e n  �� 4  ���d
�d 
cobj m  ���c�c  o  ���b�b  0 windowposition windowPosition�f  �e   o      �a�a 0 ydiff yDiff �` l ���_�^�]�_  �^  �]  �`  �  l ���\�[�Z�\  �[  �Z    I ���Y�X
�Y .ascrcmnt****      � **** J  ��  o  ���W�W 0 
windowsize 
windowSize  o  ���V�V  0 windowposition windowPosition  o  ���U�U 0 xdiff xDiff �T o  ���S�S 0 ydiff yDiff�T  �X    l ���R�Q�P�R  �Q  �P    !  r  ��"#" m  ���O�O # o      �N�N "0 windowoffsetinc windowOffsetInc! $%$ r  �&'& ]  � ()( l ��*�M�L* \  ��+,+ l ��-�K�J- I ���I.�H
�I .corecnte****       ****. 2 ���G
�G 
cwin�H  �K  �J  , m  ���F�F �M  �L  ) o  ���E�E "0 windowoffsetinc windowOffsetInc' o      �D�D 0 windowoffset windowOffset% /0/ l �C�B�A�C  �B  �A  0 121 Y  Z3�@45�?3 k  U66 787 r  /9:9 J  +;; <=< [  >?> l @�>�=@ n  ABA 4  �<C
�< 
cobjC m  �;�; B o  �:�:  0 windowposition windowPosition�>  �=  ? l D�9�8D o  �7�7 0 windowoffset windowOffset�9  �8  = E�6E [  )FGF l %H�5�4H n  %IJI 4  "%�3K
�3 
cobjK m  #$�2�2 J o  "�1�1  0 windowposition windowPosition�5  �4  G l %(L�0�/L o  %(�.�. 0 windowoffset windowOffset�0  �/  �6  : o      �-�- &0 newwindowposition newWindowPosition8 MNM l 00�,OP�,  O ; 5 log {newWindowSize, newWindowPosition, xDiff, yDiff}   P �QQ j   l o g   { n e w W i n d o w S i z e ,   n e w W i n d o w P o s i t i o n ,   x D i f f ,   y D i f f }N RSR l 00�+�*�)�+  �*  �)  S TUT r  0<VWV o  03�(�( &0 newwindowposition newWindowPositionW n      XYX 1  7;�'
�' 
posnY 4  37�&Z
�& 
cwinZ o  56�%�% 0 w  U [\[ r  =I]^] o  =@�$�$ 0 
windowsize 
windowSize^ n      _`_ 1  DH�#
�# 
ptsz` 4  @D�"a
�" 
cwina o  BC�!�! 0 w  \ b� b r  JUcdc \  JQefe o  JM�� 0 windowoffset windowOffsetf o  MP�� "0 windowoffsetinc windowOffsetIncd o      �� 0 windowoffset windowOffset�   �@ 0 w  4 m  	�� 5 l 	g��g I 	�h�
� .corecnte****       ****h 2 	�
� 
cwin�  �  �  �?  2 iji l [[����  �  �  j k�k l [[����  �  �  �  � 4  )5�l
� 
pcapl l +4m��m c  +4non n  +0pqp 1  ,0�
� 
pnamq o  +,�� 0 p  o m  03�

�
 
TEXT�  �  � m  %&rr�                                                                                  sevs  alis    \  Macintosh HD                   BD ����System Events.app                                              ����            ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  ��  ��  ��  ��  ��  ��  �� 0 p  r 2  ���	
�	 
prcs��  + m  ��ss�                                                                                  sevs  alis    \  Macintosh HD                   BD ����System Events.app                                              ����            ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  ��  $ R      �tu
� .ascrerr ****      � ****t m      �
� 
clinu �v�
� 
errnv o      �� 0 num  �  % l tt�wx�  w 3 - display dialog "Error on line number " & num   x �yy Z   d i s p l a y   d i a l o g   " E r r o r   o n   l i n e   n u m b e r   "   &   n u m��  ��  ! z�z l     �� ���  �   ��  �       ��{|}~����  { �������������� &0 processestoignore processesToIgnore�� 0 getval getVal�� 0 getkeys getKeys�� 0 setwin setWin�� 0 getwin getWin
�� .aevtoappnull  �   � ****| ����� �   @} �� ����������� 0 getval getVal�� ����� �  ������ 0 thelist theList�� 0 thekey theKey��  � �������� 0 thelist theList�� 0 thekey theKey�� 0 theitem theItem� ����������
�� 
kocl
�� 
cobj
�� .corecnte****       ****
�� 
kMsg
�� 
null�� ) $�[��l kh ��,�  	�OY h[OY��O�~ ������������ 0 getkeys getKeys�� ����� �  ���� 0 thelist theList��  � �������� 0 thelist theList�� 0 responselist responseList�� 0 theitem theItem� ��������+
�� 
kocl
�� 
cobj
�� .corecnte****       ****
�� 
kMsg�� 0jvE�O &�[��l kh ��,� ��,�6FY h[OY��O� ��<���������� 0 setwin setWin�� ����� �  ������������ 0 win  �� 0 x  �� 0 y  �� 0 xpos  �� 0 ypos  ��  � ���������������� 0 win  �� 0 x  �� 0 y  �� 0 xpos  �� 0 ypos  ��  0 windowposition windowPosition�� 0 
windowsize 
windowSize� ������ 0 position  
�� 
ptsz�� ��lvE�O��lvE�O���,FO���,F� ��h���������� 0 getwin getWin�� ����� �  ������������ 0 win  �� 0 x  �� 0 y  �� 0 xpos  �� 0 ypos  ��  � ���������������� 0 win  �� 0 x  �� 0 y  �� 0 xpos  �� 0 ypos  ��  0 windowposition windowPosition�� 0 
windowsize 
windowSize�  �� ��lvE�O��lvE�O��lv� �����������
�� .aevtoappnull  �   � ****� k    u��  N��  l�� ��� ��� ��� ��  ����  ��  ��  � ������������ 0 i  �� 0 x  �� 0 p  �� 0 w  �� 0 num  � W i���������������� ����������������������������������������������������������������������������������~�}�|�{�z�y�x�w�v�uj�t�s�r�q�p�o�n�m�l���k�j�iC�h�g��f�e�d�c�b
�� 
desk
�� 
cwin
�� 
pbnd�� 0 _b  
�� 
cobj�� 0 screen_width  �� �� 0 screen_height  ������ 0 min_xpos  
�� 
pcap�� 0 allprocesses allProcesses
�� .corecnte****       ****
�� 
prcs
�� 
pnam
�� 
TEXT
�� 
posn�� 0 winpos winPos�� 0 _x  �� 0 _y  
�� 
ptsz�� 0 winsize winSize�� 0 _w  �� 0 _h  �����  ��  
�� 
kMsg�� 0 x  ��M�� 0 y  ���� 0 xpos  ���p�� 0 ypos  ����� 
��H���� ���������� 5�� �� 0 	mywindows 	myWindows� 0 getkeys getKeys�~ 0 supportedapps supportedApps�} &0 showwindowdetails showWindowDetails
�| 
kocl
�{ 
bkgo�z 0 appname appName�y 0 
windowscnt 
windowsCnt�x 0 
windowsize 
windowSize�w  0 windowposition windowPosition�v 0 xdiff xDiff�u 0 ydiff yDiff�t 
�s .ascrcmnt****      � ****�r 0 getval getVal�q 0 windowdetails windowDetails�p �o "0 windowoffsetinc windowOffsetInc�n 0 windowoffset windowOffset
�m 
null
�l 
clin� �a�`�_
�a 
errn�` 0 num  �_  �  
�k 
pisf�j $0 frontmostprocess frontmostProcess
�i 
pvis
�h .sysodelanull��� ��� nmbr�g 0 	activeapp 	activeApp�f��e��d�w�c���b &0 newwindowposition newWindowPosition��v� *�,�,�,E�O��m/E�O���/E�UO� ��E�O*�-E�O �k�j kh  b   *�/a ,a & � �*�/ � k*�-j kh *�/a ,E` O_ �k/E` O_ �l/E` O*�/a ,E` O_ �k/E` O_ �l/E` O_ � a E` O_ _ lv*�/a ,FY h[OY��OPUW X  hY h[OY�JUOa a a a  a !a "a #a $a %a &a 'a a (a a )a !a *a #a $a %a +a 'a a ,a a )a !a *a #a -a %a .a 'a a /a a )a !a *a #a -a %a 0a 'a a 1la 2vE` 3O)_ 3k+ 4E` 5OfE` 6O���_ 6 � �*�-[a 7�l kh �a 8,f  ��a ,E` 9O*�-j E` :O� x*�a ,a &/ h*�-j E` :O*�k/a ,E` ;O*�k/a ,E` <O_ ;�k/_ <�k/E` =O_ ;�l/_ <�l/E` >Oa ?_ 9_ ;_ <_ =_ >a @vj AOPUUY h[OY�[Y hO*�-[a 7�l kh �a 8,f  �a ,E` 9O_ 5_ 9 �*�-j E` :O)_ 3_ 9l+ BE` CO� �*�a ,a &/ �*�-j E` :Oa DE` EO*�-j k_ E E` FO yk*�-j kh _ Ca G \_ Ca #,_ F_ Ca %,_ FlvE` <O_ Ca ,_ Ca !,lvE` ;O_ <*�/a ,FO_ ;*�/a ,FO_ F_ EE` FY h[OY��OPUUY hY h[OY�OPUOPW X H IhO���*�k/a J[a K,\Ze81E` LOf_ La M,FO h_ La K,e a Nj O[OY��O*�k/a ,a J[a K,\Ze81E` PO_ Pj AO*�-[a 7�l kh �a 8,f ^�a ,E` 9O_ 9_ P F_ 9j AO�6*�a ,a &/&*�-j E` :O_ :j AO_ 9a Q  Da Ra SlvE` ;Oa Ta UlvE` <O_ ;�k/_ <�k/E` =O_ ;�l/_ <�l/E` >OPY A*�k/a ,E` ;O*�k/a ,E` <O_ ;�k/_ <�k/E` =O_ ;�l/_ <�l/E` >OPO_ ;_ <_ =_ >�vj AOa DE` EO*�-j k_ E E` FO Tk*�-j kh _ <�k/_ F_ <�l/_ FlvE` VO_ V*�/a ,FO_ ;*�/a ,FO_ F_ EE` F[OY��OPUUY hY h[OY��UW X H Ih ascr  ��ޭ