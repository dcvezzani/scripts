FasdUAS 1.101.10   ��   ��    k             l      ��  ��   
set response to display dialog "Which app windows to gather?" default answer "MacVim" with icon note buttons {"Continue", "Cancel"} default button "Continue"set targetAppName to (item 2 of (text of response))log targetAppNamelog (path to frontmost application as text)     � 	 	& 
 s e t   r e s p o n s e   t o   d i s p l a y   d i a l o g   " W h i c h   a p p   w i n d o w s   t o   g a t h e r ? "   d e f a u l t   a n s w e r   " M a c V i m "   w i t h   i c o n   n o t e   b u t t o n s   { " C o n t i n u e " ,   " C a n c e l " }   d e f a u l t   b u t t o n   " C o n t i n u e "   s e t   t a r g e t A p p N a m e   t o   ( i t e m   2   o f   ( t e x t   o f   r e s p o n s e ) )  l o g   t a r g e t A p p N a m e   l o g   ( p a t h   t o   f r o n t m o s t   a p p l i c a t i o n   a s   t e x t )    
  
 l     ��������  ��  ��        i        I      �� ���� 0 getval getVal      o      ���� 0 thelist theList   ��  o      ���� 0 thekey theKey��  ��    k     (       X     % ��   Z       ����  l    ����  =        n        1    ��
�� 
kMsg  o    ���� 0 theitem theItem  o    ���� 0 thekey theKey��  ��    k          ! " ! L     # # o    ���� 0 theitem theItem "  $�� $  S    ��  ��  ��  �� 0 theitem theItem  o    ���� 0 thelist theList   %�� % L   & ( & & m   & '��
�� 
null��     ' ( ' l     ��������  ��  ��   (  ) * ) i    + , + I      �� -���� 0 getkeys getKeys -  .�� . o      ���� 0 thelist theList��  ��   , k     / / /  0 1 0 r      2 3 2 J     ����   3 o      ���� 0 responselist responseList 1  4 5 4 X    , 6�� 7 6 Z    ' 8 9���� 8 l    :���� : >    ; < ; n     = > = 1    ��
�� 
kMsg > o    ���� 0 theitem theItem < m     ? ? � @ @  d o n e��  ��   9 r    # A B A l     C���� C n      D E D 1     ��
�� 
kMsg E o    ���� 0 theitem theItem��  ��   B l      F���� F n       G H G  ;   ! " H o     !���� 0 responselist responseList��  ��  ��  ��  �� 0 theitem theItem 7 o    	���� 0 thelist theList 5  I�� I L   - / J J o   - .���� 0 responselist responseList��   *  K L K l     ��������  ��  ��   L  M N M i    O P O I      �� Q���� 0 setwin setWin Q  R S R o      ���� 0 win   S  T U T o      ���� 0 x   U  V W V o      ���� 0 y   W  X Y X o      ���� 0 xpos   Y  Z�� Z o      ���� 0 ypos  ��  ��   P k      [ [  \ ] \ r      ^ _ ^ J      ` `  a b a o     ���� 0 xpos   b  c�� c o    ���� 0 ypos  ��   _ o      ����  0 windowposition windowPosition ]  d e d r     f g f J     h h  i j i o    ���� 0 x   j  k�� k o    	���� 0 y  ��   g o      ���� 0 
windowsize 
windowSize e  l m l r     n o n o    ����  0 windowposition windowPosition o n       p q p o    ���� 0 position   q o    ���� 0 win   m  r�� r r     s t s o    ���� 0 
windowsize 
windowSize t n       u v u 1    ��
�� 
ptsz v o    ���� 0 win  ��   N  w x w l     ��������  ��  ��   x  y z y i    { | { I      �� }���� 0 getwin getWin }  ~  ~ o      ���� 0 win     � � � o      ���� 0 x   �  � � � o      ���� 0 y   �  � � � o      ���� 0 xpos   �  ��� � o      ���� 0 ypos  ��  ��   | k      � �  � � � r      � � � J      � �  � � � o     ���� 0 xpos   �  ��� � o    ���� 0 ypos  ��   � o      ����  0 windowposition windowPosition �  � � � r     � � � J     � �  � � � o    ���� 0 x   �  ��� � o    	���� 0 y  ��   � o      ���� 0 
windowsize 
windowSize �  ��� � L     � � J     � �  � � � o    ���� 0 
windowsize 
windowSize �  ��� � o    ����  0 windowposition windowPosition��  ��   z  � � � l     ��������  ��  ��   �  � � � l      �� � ���   �UO
set myWindows to {
{key: "Mail", x: 840, y: 513, xpos: 5760, ypos: 82},
{key: "Skype for Business", x: 840, y: 513, xpos: 5760, ypos: 596},
{key: "Messages", x: 840, y: 513, xpos: 6600, ypos: 596},
{key: "Teams", x: 840, y: 513, xpos: 6600, ypos: 82},
{key: "Google Chrome", x: 2000, y: 1000, xpos: 3500, ypos: -300},
{key: "done"}
}
    � � � �� 
 s e t   m y W i n d o w s   t o   { 
 { k e y :   " M a i l " ,   x :   8 4 0 ,   y :   5 1 3 ,   x p o s :   5 7 6 0 ,   y p o s :   8 2 } , 
 { k e y :   " S k y p e   f o r   B u s i n e s s " ,   x :   8 4 0 ,   y :   5 1 3 ,   x p o s :   5 7 6 0 ,   y p o s :   5 9 6 } , 
 { k e y :   " M e s s a g e s " ,   x :   8 4 0 ,   y :   5 1 3 ,   x p o s :   6 6 0 0 ,   y p o s :   5 9 6 } , 
 { k e y :   " T e a m s " ,   x :   8 4 0 ,   y :   5 1 3 ,   x p o s :   6 6 0 0 ,   y p o s :   8 2 } , 
 { k e y :   " G o o g l e   C h r o m e " ,   x :   2 0 0 0 ,   y :   1 0 0 0 ,   x p o s :   3 5 0 0 ,   y p o s :   - 3 0 0 } , 
 { k e y :   " d o n e " } 
 } 
 �  � � � l     ��������  ��  ��   �  � � � l    H ����� � r     H � � � J     D � �  � � � K      � � �� � �
�� 
kMsg � m     � � � � �  C a l e n d a r � �� � ��� 0 x   � m    ����M � �� � ��� 0 y   � m    ���� � �� � ��� 0 xpos   � m    �����p � �� ����� 0 ypos   � m   	 
�������   �  � � � K     � � �� � �
�� 
kMsg � m     � � � � �  M a i l � �� � ��� 0 x   � m    ����H � �� � ��� 0 y   � m    ���� � �� � ��� 0 xpos   � m    �����p � �� ����� 0 ypos   � m    ���� ���   �  � � � K    ( � � �� � �
�� 
kMsg � m     � � � � �  M e s s a g e s � � � �� 0 x   � m    �~�~H � �} � ��} 0 y   � m    �|�| � �{ � ��{ 0 xpos   � m    "�z�z�� � �y ��x�y 0 ypos   � m   # &�w�w��x   �  � � � K   ( : � � �v � �
�v 
kMsg � m   ) , � � � � � 
 T e a m s � �u � ��u 0 x   � m   - .�t�tH � �s � ��s 0 y   � m   / 0�r�r � �q � ��q 0 xpos   � m   1 4�p�p�� � �o ��n�o 0 ypos   � m   5 8�m�m 5�n   �  ��l � K   : @ � � �k ��j
�k 
kMsg � m   ; > � � � � �  d o n e�j  �l   � o      �i�i 0 	mywindows 	myWindows��  ��   �  � � � l     �h � ��h   � %  300, 0, 6630, 112, -6330, -112    � � � � >   3 0 0 ,   0 ,   6 6 3 0 ,   1 1 2 ,   - 6 3 3 0 ,   - 1 1 2 �  � � � l     �g � ��g   � ' ! x:840, y:513, xpos:6600, ypos:82    � � � � B   x : 8 4 0 ,   y : 5 1 3 ,   x p o s : 6 6 0 0 ,   y p o s : 8 2 �  � � � l     �f � ��f   � D > {key:"Google Chrome", x:2000, y:1000, xpos:3500, ypos:-300},     � � � � |   { k e y : " G o o g l e   C h r o m e " ,   x : 2 0 0 0 ,   y : 1 0 0 0 ,   x p o s : 3 5 0 0 ,   y p o s : - 3 0 0 } ,   �  � � � l     �e�d�c�e  �d  �c   �  � � � l     �b � ��b   � m g set supportedApps to {"Mail", "Skype for Business", "Messages", "MacVim", "Google Chrome", "Calendar"}    � � � � �   s e t   s u p p o r t e d A p p s   t o   { " M a i l " ,   " S k y p e   f o r   B u s i n e s s " ,   " M e s s a g e s " ,   " M a c V i m " ,   " G o o g l e   C h r o m e " ,   " C a l e n d a r " } �    l  I U�a�` r   I U l  I Q�_�^ n  I Q I   J Q�]�\�] 0 getkeys getKeys 	�[	 o   J M�Z�Z 0 	mywindows 	myWindows�[  �\    f   I J�_  �^   o      �Y�Y 0 supportedapps supportedApps�a  �`   

 l     �X�X     log supportedApps    � $   l o g   s u p p o r t e d A p p s  l  V [�W�V r   V [ m   V W�U
�U boovfals o      �T�T &0 showwindowdetails showWindowDetails�W  �V    l     �S�R�Q�S  �R  �Q    l  \l�P�O Q   \l k   _c  O   _a  k   e`!! "#" Z   e?$%�N�M$ o   e h�L�L &0 showwindowdetails showWindowDetails% X   k;&�K'& Z   �6()�J�I( =  � �*+* n   � �,-, 1   � ��H
�H 
bkgo- o   � ��G�G 0 p  + m   � ��F
�F boovfals) k   �2.. /0/ r   � �121 n   � �343 1   � ��E
�E 
pnam4 o   � ��D�D 0 p  2 o      �C�C 0 appname appName0 565 r   � �787 I  � ��B9�A
�B .corecnte****       ****9 2  � ��@
�@ 
cwin�A  8 o      �?�? 0 
windowscnt 
windowsCnt6 :;: l  � ��>�=�<�>  �=  �<  ; <=< l  � ��;>?�;  >   log appName   ? �@@    l o g   a p p N a m e= A�:A O  �2BCB O   �1DED k   �0FF GHG r   � �IJI I  � ��9K�8
�9 .corecnte****       ****K 2  � ��7
�7 
cwin�8  J o      �6�6 0 
windowscnt 
windowsCntH LML r   � �NON n   � �PQP 1   � ��5
�5 
ptszQ 4   � ��4R
�4 
cwinR m   � ��3�3 O o      �2�2 0 
windowsize 
windowSizeM STS r   � �UVU n   � �WXW 1   � ��1
�1 
posnX 4   � ��0Y
�0 
cwinY m   � ��/�/ V o      �.�.  0 windowposition windowPositionT Z[Z r   � �\]\ \   � �^_^ l  � �`�-�,` n   � �aba 4   � ��+c
�+ 
cobjc m   � ��*�* b o   � ��)�) 0 
windowsize 
windowSize�-  �,  _ l  � �d�(�'d n   � �efe 4   � ��&g
�& 
cobjg m   � ��%�% f o   � ��$�$  0 windowposition windowPosition�(  �'  ] o      �#�# 0 xdiff xDiff[ hih r   �jkj \   �lml l  �n�"�!n n   �opo 4  � q
�  
cobjq m  �� p o   ��� 0 
windowsize 
windowSize�"  �!  m l r��r n  sts 4  	�u
� 
cobju m  �� t o  	��  0 windowposition windowPosition�  �  k o      �� 0 ydiff yDiffi vwv l ����  �  �  w xyx I .�z�
� .ascrcmnt****      � ****z J  *{{ |}| m  ~~ �  w i n d o w I n f o} ��� o  �� 0 appname appName� ��� o  �� 0 
windowsize 
windowSize� ��� o   ��  0 windowposition windowPosition� ��� o   #�� 0 xdiff xDiff� ��� o  #&�� 0 ydiff yDiff�  �  y ��� l //��
�	�  �
  �	  �  E 4   � ���
� 
pcap� l  � ����� c   � ���� n   � ���� 1   � ��
� 
pnam� o   � ��� 0 p  � m   � ��
� 
TEXT�  �  C m   � ����                                                                                  sevs  alis    \  Macintosh HD                   BD ����System Events.app                                              ����            ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  �:  �J  �I  �K 0 p  ' 2   n s�
� 
prcs�N  �M  # ��� l @@�� ���  �   ��  � ��� X  @^����� Z  XY������� = X_��� n  X]��� 1  Y]��
�� 
bkgo� o  XY���� 0 p  � m  ]^��
�� boovfals� k  bU�� ��� r  bk��� n  bg��� 1  cg��
�� 
pnam� o  bc���� 0 p  � o      ���� 0 appname appName� ���� Z  lU������� E  ls��� o  lo���� 0 supportedapps supportedApps� o  or���� 0 appname appName� k  vQ�� ��� r  v���� I v�����
�� .corecnte****       ****� 2 v{��
�� 
cwin��  � o      ���� 0 
windowscnt 
windowsCnt� ��� r  ����� l �������� n ����� I  ��������� 0 getval getVal� ��� o  ������ 0 	mywindows 	myWindows� ���� o  ������ 0 appname appName��  ��  �  f  ����  ��  � o      ���� 0 windowdetails windowDetails� ��� l ����������  ��  ��  � ���� O �Q��� O  �P��� k  �O�� ��� r  ����� I �������
�� .corecnte****       ****� 2 ����
�� 
cwin��  � o      ���� 0 
windowscnt 
windowsCnt� ��� r  ����� m  ������ � o      ���� "0 windowoffsetinc windowOffsetInc� ��� r  ����� ]  ����� l �������� \  ����� l �������� I �������
�� .corecnte****       ****� 2 ����
�� 
cwin��  ��  ��  � m  ������ ��  ��  � o  ������ "0 windowoffsetinc windowOffsetInc� o      ���� 0 windowoffset windowOffset� ��� l ����������  ��  ��  � ��� Y  �M�������� Z  �H������� > ����� o  ������ 0 windowdetails windowDetails� m  ����
�� 
null� k  �D�� ��� r  �	��� J  ��� ��� [  ����� l �������� n  ����� o  ������ 0 xpos  � o  ������ 0 windowdetails windowDetails��  ��  � o  ������ 0 windowoffset windowOffset� ���� [  ���� l �������� n  ����� o  ������ 0 ypos  � o  ������ 0 windowdetails windowDetails��  ��  � o  ����� 0 windowoffset windowOffset��  � o      ����  0 windowposition windowPosition� ��� r  
��� J  
�� ��� n  
��� o  ���� 0 x  � o  
���� 0 windowdetails windowDetails� ���� n  ��� o  ���� 0 y  � o  ���� 0 windowdetails windowDetails��  � o      ���� 0 
windowsize 
windowSize�    r  ) o  ����  0 windowposition windowPosition n       1  $(��
�� 
posn 4  $��
�� 
cwin o  "#���� 0 w    r  *8	
	 o  *-���� 0 
windowsize 
windowSize
 n       1  37��
�� 
ptsz 4  -3��
�� 
cwin o  12���� 0 w   �� r  9D \  9@ o  9<���� 0 windowoffset windowOffset o  <?���� "0 windowoffsetinc windowOffsetInc o      ���� 0 windowoffset windowOffset��  ��  ��  �� 0 w  � m  ������ � l ������ I ������
�� .corecnte****       **** 2 ����
�� 
cwin��  ��  ��  ��  � �� l NN��������  ��  ��  ��  � 4  ����
�� 
pcap l ������ c  �� n  �� 1  ����
�� 
pnam o  ������ 0 p   m  ����
�� 
TEXT��  ��  � m  ���                                                                                  sevs  alis    \  Macintosh HD                   BD ����System Events.app                                              ����            ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  ��  ��  ��  ��  ��  ��  �� 0 p  � 2  CH��
�� 
prcs�  l __��������  ��  ��     l  __��!"��  !��
	repeat with p in every process		if background only of p is false then			set appName to name of p			-- log appName			-- log (appName is activeApp)						log appName						try				tell application "System Events" to tell application process (name of p as string)					set windowsCnt to count of windows					-- log windowsCnt										set windowSize to size of window 1					set windowPosition to position of window 1					set xDiff to (item 1 of windowSize) - (item 1 of windowPosition)					set yDiff to (item 2 of windowSize) - (item 2 of windowPosition)										-- log {"windowInfo", appName, windowSize, windowPosition, xDiff, yDiff}				end tell			on error line number num				-- display dialog "Error on line number " & num			end try		end if	end repeat		repeat with p in every process		try			if background only of p is false then				set appName to name of p				set windowDetails to (my getVal(myWindows, appName))								tell application "System Events" to tell application process (name of p as string)					set windowsCnt to count of windows										set windowOffsetInc to 30					set windowOffset to ((count of windows) - 1) * windowOffsetInc										repeat with w from 1 to (count of windows)												if windowDetails is not null then							set windowPosition to {(xpos of windowDetails) + windowOffset, (ypos of windowDetails) + windowOffset}							set windowSize to {x of windowDetails, y of windowDetails}							set position of window w to windowPosition							set size of window w to windowSize							set windowOffset to windowOffset - windowOffsetInc						end if					end repeat									end tell			end if		on error line number num			display dialog (get properties of p)		end try	end repeat
	   " �##� 
 	 r e p e a t   w i t h   p   i n   e v e r y   p r o c e s s  	 	 i f   b a c k g r o u n d   o n l y   o f   p   i s   f a l s e   t h e n  	 	 	 s e t   a p p N a m e   t o   n a m e   o f   p  	 	 	 - -   l o g   a p p N a m e  	 	 	 - -   l o g   ( a p p N a m e   i s   a c t i v e A p p )  	 	 	  	 	 	 l o g   a p p N a m e  	 	 	  	 	 	 t r y  	 	 	 	 t e l l   a p p l i c a t i o n   " S y s t e m   E v e n t s "   t o   t e l l   a p p l i c a t i o n   p r o c e s s   ( n a m e   o f   p   a s   s t r i n g )  	 	 	 	 	 s e t   w i n d o w s C n t   t o   c o u n t   o f   w i n d o w s  	 	 	 	 	 - -   l o g   w i n d o w s C n t  	 	 	 	 	  	 	 	 	 	 s e t   w i n d o w S i z e   t o   s i z e   o f   w i n d o w   1  	 	 	 	 	 s e t   w i n d o w P o s i t i o n   t o   p o s i t i o n   o f   w i n d o w   1  	 	 	 	 	 s e t   x D i f f   t o   ( i t e m   1   o f   w i n d o w S i z e )   -   ( i t e m   1   o f   w i n d o w P o s i t i o n )  	 	 	 	 	 s e t   y D i f f   t o   ( i t e m   2   o f   w i n d o w S i z e )   -   ( i t e m   2   o f   w i n d o w P o s i t i o n )  	 	 	 	 	  	 	 	 	 	 - -   l o g   { " w i n d o w I n f o " ,   a p p N a m e ,   w i n d o w S i z e ,   w i n d o w P o s i t i o n ,   x D i f f ,   y D i f f }  	 	 	 	 e n d   t e l l  	 	 	 o n   e r r o r   l i n e   n u m b e r   n u m  	 	 	 	 - -   d i s p l a y   d i a l o g   " E r r o r   o n   l i n e   n u m b e r   "   &   n u m  	 	 	 e n d   t r y  	 	 e n d   i f  	 e n d   r e p e a t  	  	 r e p e a t   w i t h   p   i n   e v e r y   p r o c e s s  	 	 t r y  	 	 	 i f   b a c k g r o u n d   o n l y   o f   p   i s   f a l s e   t h e n  	 	 	 	 s e t   a p p N a m e   t o   n a m e   o f   p  	 	 	 	 s e t   w i n d o w D e t a i l s   t o   ( m y   g e t V a l ( m y W i n d o w s ,   a p p N a m e ) )  	 	 	 	  	 	 	 	 t e l l   a p p l i c a t i o n   " S y s t e m   E v e n t s "   t o   t e l l   a p p l i c a t i o n   p r o c e s s   ( n a m e   o f   p   a s   s t r i n g )  	 	 	 	 	 s e t   w i n d o w s C n t   t o   c o u n t   o f   w i n d o w s  	 	 	 	 	  	 	 	 	 	 s e t   w i n d o w O f f s e t I n c   t o   3 0  	 	 	 	 	 s e t   w i n d o w O f f s e t   t o   ( ( c o u n t   o f   w i n d o w s )   -   1 )   *   w i n d o w O f f s e t I n c  	 	 	 	 	  	 	 	 	 	 r e p e a t   w i t h   w   f r o m   1   t o   ( c o u n t   o f   w i n d o w s )  	 	 	 	 	 	  	 	 	 	 	 	 i f   w i n d o w D e t a i l s   i s   n o t   n u l l   t h e n  	 	 	 	 	 	 	 s e t   w i n d o w P o s i t i o n   t o   { ( x p o s   o f   w i n d o w D e t a i l s )   +   w i n d o w O f f s e t ,   ( y p o s   o f   w i n d o w D e t a i l s )   +   w i n d o w O f f s e t }  	 	 	 	 	 	 	 s e t   w i n d o w S i z e   t o   { x   o f   w i n d o w D e t a i l s ,   y   o f   w i n d o w D e t a i l s }  	 	 	 	 	 	 	 s e t   p o s i t i o n   o f   w i n d o w   w   t o   w i n d o w P o s i t i o n  	 	 	 	 	 	 	 s e t   s i z e   o f   w i n d o w   w   t o   w i n d o w S i z e  	 	 	 	 	 	 	 s e t   w i n d o w O f f s e t   t o   w i n d o w O f f s e t   -   w i n d o w O f f s e t I n c  	 	 	 	 	 	 e n d   i f  	 	 	 	 	 e n d   r e p e a t  	 	 	 	 	  	 	 	 	 e n d   t e l l  	 	 	 e n d   i f  	 	 o n   e r r o r   l i n e   n u m b e r   n u m  	 	 	 d i s p l a y   d i a l o g   ( g e t   p r o p e r t i e s   o f   p )  	 	 e n d   t r y  	 e n d   r e p e a t 
 	  $��$ l __��������  ��  ��  ��    m   _ b%%�                                                                                  sevs  alis    \  Macintosh HD                   BD ����System Events.app                                              ����            ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��   &��& l bb��������  ��  ��  ��   R      ��'(
�� .ascrerr ****      � ****' m      ��
�� 
clin( ��)��
�� 
errn) o      ���� 0 num  ��   l kk��*+��  * 3 - display dialog "Error on line number " & num   + �,, Z   d i s p l a y   d i a l o g   " E r r o r   o n   l i n e   n u m b e r   "   &   n u m�P  �O   -��- l     ��������  ��  ��  ��       ��./0123��  . ������~�}�� 0 getval getVal�� 0 getkeys getKeys� 0 setwin setWin�~ 0 getwin getWin
�} .aevtoappnull  �   � ****/ �| �{�z45�y�| 0 getval getVal�{ �x6�x 6  �w�v�w 0 thelist theList�v 0 thekey theKey�z  4 �u�t�s�u 0 thelist theList�t 0 thekey theKey�s 0 theitem theItem5 �r�q�p�o�n
�r 
kocl
�q 
cobj
�p .corecnte****       ****
�o 
kMsg
�n 
null�y ) $�[��l kh ��,�  	�OY h[OY��O�0 �m ,�l�k78�j�m 0 getkeys getKeys�l �i9�i 9  �h�h 0 thelist theList�k  7 �g�f�e�g 0 thelist theList�f 0 responselist responseList�e 0 theitem theItem8 �d�c�b�a ?
�d 
kocl
�c 
cobj
�b .corecnte****       ****
�a 
kMsg�j 0jvE�O &�[��l kh ��,� ��,�6FY h[OY��O�1 �` P�_�^:;�]�` 0 setwin setWin�_ �\<�\ <  �[�Z�Y�X�W�[ 0 win  �Z 0 x  �Y 0 y  �X 0 xpos  �W 0 ypos  �^  : �V�U�T�S�R�Q�P�V 0 win  �U 0 x  �T 0 y  �S 0 xpos  �R 0 ypos  �Q  0 windowposition windowPosition�P 0 
windowsize 
windowSize; �O�N�O 0 position  
�N 
ptsz�] ��lvE�O��lvE�O���,FO���,F2 �M |�L�K=>�J�M 0 getwin getWin�L �I?�I ?  �H�G�F�E�D�H 0 win  �G 0 x  �F 0 y  �E 0 xpos  �D 0 ypos  �K  = �C�B�A�@�?�>�=�C 0 win  �B 0 x  �A 0 y  �@ 0 xpos  �? 0 ypos  �>  0 windowposition windowPosition�= 0 
windowsize 
windowSize>  �J ��lvE�O��lvE�O��lv3 �<@�;�:AB�9
�< .aevtoappnull  �   � ****@ k    lCC  �DD  EE FF �8�8  �;  �:  A �7�6�5�7 0 p  �6 0 w  �5 0 num  B 7�4 ��3�2�1�0�/�.�-�,�+ ��*�)�( ��'�& ��% ��$�#�"�!� %�����������������~�����
�	���G
�4 
kMsg�3 0 x  �2M�1 0 y  �0�/ 0 xpos  �.�p�- 0 ypos  �,��+ 
�*H�)�( ��'���&��% 5�$ �# 0 	mywindows 	myWindows�" 0 getkeys getKeys�! 0 supportedapps supportedApps�  &0 showwindowdetails showWindowDetails
� 
prcs
� 
kocl
� 
cobj
� .corecnte****       ****
� 
bkgo
� 
pnam� 0 appname appName
� 
cwin� 0 
windowscnt 
windowsCnt
� 
pcap
� 
TEXT
� 
ptsz� 0 
windowsize 
windowSize
� 
posn�  0 windowposition windowPosition� 0 xdiff xDiff� 0 ydiff yDiff� 
� .ascrcmnt****      � ****� 0 getval getVal� 0 windowdetails windowDetails�
 �	 "0 windowoffsetinc windowOffsetInc� 0 windowoffset windowOffset
� 
null
� 
clinG ���
� 
errn� 0 num  �  �9m�����������������������������a �a ��a �����a �a ��a la vE` O)_ k+ E` OfE` O	a �_  � �*a -[a a l kh  �a ,f  ��a  ,E` !O*a "-j E` #Oa  �*a $�a  ,a %&/ v*a "-j E` #O*a "k/a &,E` 'O*a "k/a (,E` )O_ 'a k/_ )a k/E` *O_ 'a l/_ )a l/E` +Oa ,_ !_ '_ )_ *_ +a -vj .OPUUY h[OY�GY hO*a -[a a l kh  �a ,f  ��a  ,E` !O_ _ ! �*a "-j E` #O)_ _ !l+ /E` 0Oa  �*a $�a  ,a %&/ �*a "-j E` #Oa 1E` 2O*a "-j k_ 2 E` 3O wk*a "-j kh _ 0a 4 X_ 0�,_ 3_ 0�,_ 3lvE` )O_ 0�,_ 0�,lvE` 'O_ )*a "�/a (,FO_ '*a "�/a &,FO_ 3_ 2E` 3Y h[OY��OPUUY hY h[OY��OPUOPW X 5 6hascr  ��ޭ