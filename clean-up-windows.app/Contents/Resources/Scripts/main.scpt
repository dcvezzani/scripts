FasdUAS 1.101.10   ��   ��    k             l     ��  ��    ` Z Source: http://www.jonathanlaliberte.com/2007/10/19/move-all-windows-to-your-main-screen/     � 	 	 �   S o u r c e :   h t t p : / / w w w . j o n a t h a n l a l i b e r t e . c o m / 2 0 0 7 / 1 0 / 1 9 / m o v e - a l l - w i n d o w s - t o - y o u r - m a i n - s c r e e n /   
  
 l     ��  ��    I C and: http://www.macosxhints.com/article.php?story=2007102012424539     �   �   a n d :   h t t p : / / w w w . m a c o s x h i n t s . c o m / a r t i c l e . p h p ? s t o r y = 2 0 0 7 1 0 2 0 1 2 4 2 4 5 3 9      l     ��������  ��  ��        l     ��  ��      Improvements:     �      I m p r o v e m e n t s :      l     ��  ��    5 / +  code is more efficient and more elegant now     �   ^   +     c o d e   i s   m o r e   e f f i c i e n t   a n d   m o r e   e l e g a n t   n o w      l     ��  ��    L F + windows are moved also, if they are "almost" completely off-screen      �   �   +   w i n d o w s   a r e   m o v e d   a l s o ,   i f   t h e y   a r e   " a l m o s t "   c o m p l e t e l y   o f f - s c r e e n       !   l     �� " #��   " _ Y      (in the orig. version, they would be moved only if they were completely off-screen)    # � $ $ �             ( i n   t h e   o r i g .   v e r s i o n ,   t h e y   w o u l d   b e   m o v e d   o n l y   i f   t h e y   w e r e   c o m p l e t e l y   o f f - s c r e e n ) !  % & % l     �� ' (��   ' R L + windows are moved (if they are moved) to their closest position on-screen    ( � ) ) �   +   w i n d o w s   a r e   m o v e d   ( i f   t h e y   a r e   m o v e d )   t o   t h e i r   c l o s e s t   p o s i t i o n   o n - s c r e e n &  * + * l     �� , -��   , S M     (in the orig. version, they would be moved to a "home position" (0,22) )    - � . . �           ( i n   t h e   o r i g .   v e r s i o n ,   t h e y   w o u l d   b e   m o v e d   t o   a   " h o m e   p o s i t i o n "   ( 0 , 2 2 )   ) +  / 0 / l     �� 1 2��   1 !  Gabriel Zachmann, Jan 2008    2 � 3 3 6   G a b r i e l   Z a c h m a n n ,   J a n   2 0 0 8 0  4 5 4 l     ��������  ��  ��   5  6 7 6 l     �� 8 9��   8 [ U Example list of processes to ignore: {"xGestures"} or {"xGestures", "OtherApp", ...}    9 � : : �   E x a m p l e   l i s t   o f   p r o c e s s e s   t o   i g n o r e :   { " x G e s t u r e s " }   o r   { " x G e s t u r e s " ,   " O t h e r A p p " ,   . . . } 7  ; < ; j     �� =�� &0 processestoignore processesToIgnore = J      > >  ? @ ? m      A A � B B  T y p i n a t o r @  C D C m     E E � F F  M a i l D  G H G m     I I � J J  C a l e n d a r H  K L K m     M M � N N  M e s s a g e s L  O�� O m     P P � Q Q 
 T e a m s��   <  R S R l     ��������  ��  ��   S  T U T l     �� V W��   V J D Get the size of the Display(s), only useful if there is one display    W � X X �   G e t   t h e   s i z e   o f   t h e   D i s p l a y ( s ) ,   o n l y   u s e f u l   i f   t h e r e   i s   o n e   d i s p l a y U  Y Z Y l     �� [ \��   [ = 7 otherwise it will grab the total size of both displays    \ � ] ] n   o t h e r w i s e   i t   w i l l   g r a b   t h e   t o t a l   s i z e   o f   b o t h   d i s p l a y s Z  ^ _ ^ l     `���� ` O      a b a k     c c  d e d r     f g f n     h i h 1   	 ��
�� 
pbnd i n    	 j k j m    	��
�� 
cwin k 1    ��
�� 
desk g o      ���� 0 _b   e  l m l r     n o n n     p q p 4    �� r
�� 
cobj r m    ����  q o    ���� 0 _b   o o      ���� 0 screen_width   m  s�� s r     t u t n     v w v 4    �� x
�� 
cobj x m    ����  w o    ���� 0 _b   u o      ���� 0 screen_height  ��   b m      y y�                                                                                  MACS  alis    @  Macintosh HD                   BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p    M a c i n t o s h   H D  &System/Library/CoreServices/Finder.app  / ��  ��  ��   _  z { z l     ��������  ��  ��   {  | } | l   � ~���� ~ O    �  �  k   ! � � �  � � � r   ! & � � � 2  ! $��
�� 
pcap � o      ���� 0 allprocesses allProcesses �  ��� � Y   ' � ��� � ��� � k   5 � � �  � � � l  5 5�� � ���   � 4 .display dialog (name of (process i)) as string    � � � � \ d i s p l a y   d i a l o g   ( n a m e   o f   ( p r o c e s s   i ) )   a s   s t r i n g �  ��� � Z   5 � � ����� � H   5 D � � l  5 C ����� � E   5 C � � � o   5 :���� &0 processestoignore processesToIgnore � l  : B ����� � c   : B � � � l  : @ ����� � n   : @ � � � 1   > @��
�� 
pnam � l  : > ����� � 4   : >�� �
�� 
prcs � o   < =���� 0 i  ��  ��  ��  ��   � m   @ A��
�� 
TEXT��  ��  ��  ��   � Q   G � � ��� � O   J � � � � k   Q � � �  � � � Y   Q � ��� � ��� � k   a � � �  � � � r   a m � � � n   a i � � � 1   e i��
�� 
posn � 4   a e�� �
�� 
cwin � o   c d���� 0 x   � o      ���� 0 winpos winPos �  � � � r   n x � � � n   n t � � � 4   q t�� �
�� 
cobj � m   r s����  � o   n q���� 0 winpos winPos � o      ���� 0 _x   �  � � � r   y � � � � n   y  � � � 4   | �� �
�� 
cobj � m   } ~����  � o   y |���� 0 winpos winPos � o      ���� 0 _y   �  � � � r   � � � � � n   � � � � � 1   � ���
�� 
ptsz � 4   � ��� �
�� 
cwin � o   � ����� 0 x   � o      ���� 0 winsize winSize �  � � � r   � � � � � n   � � � � � 4   � ��� �
�� 
cobj � m   � �����  � o   � ����� 0 winsize winSize � o      ���� 0 _w   �  � � � r   � � � � � n   � � � � � 4   � ��� �
�� 
cobj � m   � �����  � o   � ����� 0 winsize winSize � o      ���� 0 _h   �  � � � l  � ��� � ���   � d ^display dialog (name as string) & " - width: " & (_w as string) & " height: " & (_h as string)    � � � � � d i s p l a y   d i a l o g   ( n a m e   a s   s t r i n g )   &   "   -   w i d t h :   "   &   ( _ w   a s   s t r i n g )   &   "   h e i g h t :   "   &   ( _ h   a s   s t r i n g ) �  ��� � Z   � � � ����� � l  � � ����� � ?   � � � � � o   � ����� 0 _x   � m   � �����D��  ��   � k   � � � �  � � � r   � � � � � \   � � � � � o   � ����� 0 _x   � l  � � ����� � \   � � � � � [   � � � � � o   � ����� 0 _w   � o   � ����� 0 _x   � m   � �����D��  ��   � o      ���� 0 _x   �  ��� � r   � � � � � J   � � � �  � � � o   � ����� 0 _x   �  ��� � o   � ����� 0 _y  ��   � n       � � � 1   � ���
�� 
posn � 4   � ��� �
�� 
cwin � o   � ����� 0 x  ��  ��  ��  ��  �� 0 x   � m   T U����  � l  U \ ����� � I  U \�� ���
�� .corecnte****       **** � 2  U X��
�� 
cwin��  ��  ��  ��   �  ��� � l  � ���������  ��  ��  ��   � 4   J N�� �
�� 
prcs � o   L M���� 0 i   � R      ����~
�� .ascrerr ****      � ****�  �~  ��  ��  ��  ��  �� 0 i   � m   * +�}�}  � I  + 0�| ��{
�| .corecnte****       **** � o   + ,�z�z 0 allprocesses allProcesses�{  ��  ��   � m     � ��                                                                                  sevs  alis    \  Macintosh HD                   BD ����System Events.app                                              ����            ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  ��  ��   }  � � � l     �y�x�w�y  �x  �w   �  � � � l      �v � �v   �
set response to display dialog "Which app windows to gather?" default answer "MacVim" with icon note buttons {"Continue", "Cancel"} default button "Continue"set targetAppName to (item 2 of (text of response))log targetAppNamelog (path to frontmost application as text)     �& 
 s e t   r e s p o n s e   t o   d i s p l a y   d i a l o g   " W h i c h   a p p   w i n d o w s   t o   g a t h e r ? "   d e f a u l t   a n s w e r   " M a c V i m "   w i t h   i c o n   n o t e   b u t t o n s   { " C o n t i n u e " ,   " C a n c e l " }   d e f a u l t   b u t t o n   " C o n t i n u e "   s e t   t a r g e t A p p N a m e   t o   ( i t e m   2   o f   ( t e x t   o f   r e s p o n s e ) )  l o g   t a r g e t A p p N a m e   l o g   ( p a t h   t o   f r o n t m o s t   a p p l i c a t i o n   a s   t e x t )  �  l     �u�t�s�u  �t  �s    i  	  I      �r�q�r 0 getval getVal 	
	 o      �p�p 0 thelist theList
 �o o      �n�n 0 thekey theKey�o  �q   k     (  X     %�m Z     �l�k l   �j�i =     n     1    �h
�h 
kMsg o    �g�g 0 theitem theItem o    �f�f 0 thekey theKey�j  �i   k      L     o    �e�e 0 theitem theItem �d  S    �d  �l  �k  �m 0 theitem theItem o    �c�c 0 thelist theList �b L   & ( m   & '�a
�a 
null�b     l     �`�_�^�`  �_  �^    !"! i   #$# I      �]%�\�] 0 getkeys getKeys% &�[& o      �Z�Z 0 thelist theList�[  �\  $ k     /'' ()( r     *+* J     �Y�Y  + o      �X�X 0 responselist responseList) ,-, X    ,.�W/. Z    '01�V�U0 l   2�T�S2 >   343 n    565 1    �R
�R 
kMsg6 o    �Q�Q 0 theitem theItem4 m    77 �88  d o n e�T  �S  1 r    #9:9 l    ;�P�O; n     <=< 1     �N
�N 
kMsg= o    �M�M 0 theitem theItem�P  �O  : l     >�L�K> n      ?@?  ;   ! "@ o     !�J�J 0 responselist responseList�L  �K  �V  �U  �W 0 theitem theItem/ o    	�I�I 0 thelist theList- A�HA L   - /BB o   - .�G�G 0 responselist responseList�H  " CDC l     �F�E�D�F  �E  �D  D EFE i   GHG I      �CI�B�C 0 setwin setWinI JKJ o      �A�A 0 win  K LML o      �@�@ 0 x  M NON o      �?�? 0 y  O PQP o      �>�> 0 xpos  Q R�=R o      �<�< 0 ypos  �=  �B  H k     SS TUT r     VWV J     XX YZY o     �;�; 0 xpos  Z [�:[ o    �9�9 0 ypos  �:  W o      �8�8  0 windowposition windowPositionU \]\ r    ^_^ J    `` aba o    �7�7 0 x  b c�6c o    	�5�5 0 y  �6  _ o      �4�4 0 
windowsize 
windowSize] ded r    fgf o    �3�3  0 windowposition windowPositiong n      hih o    �2�2 0 position  i o    �1�1 0 win  e j�0j r    klk o    �/�/ 0 
windowsize 
windowSizel n      mnm 1    �.
�. 
ptszn o    �-�- 0 win  �0  F opo l     �,�+�*�,  �+  �*  p qrq i   sts I      �)u�(�) 0 getwin getWinu vwv o      �'�' 0 win  w xyx o      �&�& 0 x  y z{z o      �%�% 0 y  { |}| o      �$�$ 0 xpos  } ~�#~ o      �"�" 0 ypos  �#  �(  t k      ��� r     ��� J     �� ��� o     �!�! 0 xpos  � �� � o    �� 0 ypos  �   � o      ��  0 windowposition windowPosition� ��� r    ��� J    �� ��� o    �� 0 x  � ��� o    	�� 0 y  �  � o      �� 0 
windowsize 
windowSize� ��� L    �� J    �� ��� o    �� 0 
windowsize 
windowSize� ��� o    ��  0 windowposition windowPosition�  �  r ��� l     ����  �  �  � ��� l      ����  �UO
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
� ��� l     ����  �  �  � ��� l  ������ r   ����� J   ���� ��� K   ��� ���
� 
kMsg� m   � ��� ���  C a l e n d a r� ���� 0 x  � m   ��
�
H� �	���	 0 y  � m  ��� ���� 0 xpos  � m  ���� ���� 0 ypos  � m  ��T�  � ��� K  :�� ���
� 
kMsg� m  �� ���  M a i l� ���� 0 x  � m  !$� � H� ������ 0 y  � m  '*����� ������ 0 xpos  � m  -0������ ������� 0 ypos  � m  36���� b��  � ��� K  :\�� ����
�� 
kMsg� m  =@�� ���  M e s s a g e s� ������ 0 x  � m  CF����H� ������ 0 y  � m  IL����� ������ 0 xpos  � m  OR������ ������� 0 ypos  � m  UX����d��  � ��� K  \~�� ����
�� 
kMsg� m  _b�� ��� 
 T e a m s� ������ 0 x  � m  eh����H� ������ 0 y  � m  kn����� ������ 0 xpos  � m  qt������ ������� 0 ypos  � m  wz���� R��  � ���� K  ~��� �����
�� 
kMsg� m  ���� ���  d o n e��  ��  � o      ���� 0 	mywindows 	myWindows�  �  � ��� l     ������  � %  300, 0, 6630, 112, -6330, -112   � ��� >   3 0 0 ,   0 ,   6 6 3 0 ,   1 1 2 ,   - 6 3 3 0 ,   - 1 1 2� ��� l     ������  � ' ! x:840, y:513, xpos:6600, ypos:82   � ��� B   x : 8 4 0 ,   y : 5 1 3 ,   x p o s : 6 6 0 0 ,   y p o s : 8 2� ��� l     ������  � D > {key:"Google Chrome", x:2000, y:1000, xpos:3500, ypos:-300},    � ��� |   { k e y : " G o o g l e   C h r o m e " ,   x : 2 0 0 0 ,   y : 1 0 0 0 ,   x p o s : 3 5 0 0 ,   y p o s : - 3 0 0 } ,  � ��� l     ��������  ��  ��  � ��� l     ������  � m g set supportedApps to {"Mail", "Skype for Business", "Messages", "MacVim", "Google Chrome", "Calendar"}   � ��� �   s e t   s u p p o r t e d A p p s   t o   { " M a i l " ,   " S k y p e   f o r   B u s i n e s s " ,   " M e s s a g e s " ,   " M a c V i m " ,   " G o o g l e   C h r o m e " ,   " C a l e n d a r " }� ��� l �������� r  ����� l �������� n ����� I  ���� ���� 0 getkeys getKeys  �� o  ������ 0 	mywindows 	myWindows��  ��  �  f  ����  ��  � o      ���� 0 supportedapps supportedApps��  ��  �  l     ����     log supportedApps    � $   l o g   s u p p o r t e d A p p s  l ��	����	 r  ��

 m  ����
�� boovfals o      ���� &0 showwindowdetails showWindowDetails��  ��    l     ��������  ��  ��    l ������ Q  �� k  �w  O  �u k  �t  Z  �e���� o  ������ &0 showwindowdetails showWindowDetails X  �a�� Z  �\ !����  = ��"#" n  ��$%$ 1  ����
�� 
bkgo% o  ������ 0 p  # m  ����
�� boovfals! k  �X&& '(' r  ��)*) n  ��+,+ 1  ����
�� 
pnam, o  ������ 0 p  * o      ���� 0 appname appName( -.- r  ��/0/ I ����1��
�� .corecnte****       ****1 2 ����
�� 
cwin��  0 o      ���� 0 
windowscnt 
windowsCnt. 232 l ����������  ��  ��  3 454 l ����67��  6   log appName   7 �88    l o g   a p p N a m e5 9��9 O �X:;: O  �W<=< k  �V>> ?@? r  ��ABA I ����C��
�� .corecnte****       ****C 2 ����
�� 
cwin��  B o      ���� 0 
windowscnt 
windowsCnt@ DED r  �FGF n  �HIH 1   ��
�� 
ptszI 4  � ��J
�� 
cwinJ m  ������ G o      ���� 0 
windowsize 
windowSizeE KLK r  	MNM n  	OPO 1  ��
�� 
posnP 4  	��Q
�� 
cwinQ m  ���� N o      ����  0 windowposition windowPositionL RSR r  'TUT \  #VWV l X����X n  YZY 4  ��[
�� 
cobj[ m  ���� Z o  ���� 0 
windowsize 
windowSize��  ��  W l "\����\ n  "]^] 4  "��_
�� 
cobj_ m   !���� ^ o  ����  0 windowposition windowPosition��  ��  U o      ���� 0 xdiff xDiffS `a` r  (9bcb \  (5ded l (.f����f n  (.ghg 4  +.��i
�� 
cobji m  ,-���� h o  (+���� 0 
windowsize 
windowSize��  ��  e l .4j����j n  .4klk 4  14��m
�� 
cobjm m  23���� l o  .1����  0 windowposition windowPosition��  ��  c o      ���� 0 ydiff yDiffa non l ::��������  ��  ��  o pqp I :T��r��
�� .ascrcmnt****      � ****r J  :Pss tut m  :=vv �ww  w i n d o w I n f ou xyx o  =@���� 0 appname appNamey z{z o  @C���� 0 
windowsize 
windowSize{ |}| o  CF����  0 windowposition windowPosition} ~~ o  FI���� 0 xdiff xDiff ���� o  IL���� 0 ydiff yDiff��  ��  q ���� l UU��������  ��  ��  ��  = 4  �����
�� 
pcap� l �����~� c  ����� n  ����� 1  ���}
�} 
pnam� o  ���|�| 0 p  � m  ���{
�{ 
TEXT�  �~  ; m  �����                                                                                  sevs  alis    \  Macintosh HD                   BD ����System Events.app                                              ����            ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  ��  ��  ��  �� 0 p   2  ���z
�z 
prcs��  ��   ��� l ff�y�x�w�y  �x  �w  � ��� X  fr��v�� Z  zm���u�t� = z���� n  z��� 1  {�s
�s 
bkgo� o  z{�r�r 0 p  � m  ��q
�q boovfals� k  �i�� ��� r  ����� n  ����� 1  ���p
�p 
pnam� o  ���o�o 0 p  � o      �n�n 0 appname appName� ��m� Z  �i���l�k� E  ����� o  ���j�j 0 supportedapps supportedApps� o  ���i�i 0 appname appName� k  �e�� ��� r  ����� I ���h��g
�h .corecnte****       ****� 2 ���f
�f 
cwin�g  � o      �e�e 0 
windowscnt 
windowsCnt� ��� r  ����� l ����d�c� n ����� I  ���b��a�b 0 getval getVal� ��� o  ���`�` 0 	mywindows 	myWindows� ��_� o  ���^�^ 0 appname appName�_  �a  �  f  ���d  �c  � o      �]�] 0 windowdetails windowDetails� ��� l ���\�[�Z�\  �[  �Z  � ��Y� O �e��� O  �d��� k  �c�� ��� r  ����� I ���X��W
�X .corecnte****       ****� 2 ���V
�V 
cwin�W  � o      �U�U 0 
windowscnt 
windowsCnt� ��� r  ����� m  ���T�T � o      �S�S "0 windowoffsetinc windowOffsetInc� ��� r  ����� ]  ����� l ����R�Q� \  ����� l ����P�O� I ���N��M
�N .corecnte****       ****� 2 ���L
�L 
cwin�M  �P  �O  � m  ���K�K �R  �Q  � o  ���J�J "0 windowoffsetinc windowOffsetInc� o      �I�I 0 windowoffset windowOffset� ��� l ���H�G�F�H  �G  �F  � ��� Y  �a��E���D� Z  �\���C�B� > ����� o  ���A�A 0 windowdetails windowDetails� m  ���@
�@ 
null� k  X�� ��� r  ��� J  �� ��� [  ��� l ��?�>� n  ��� o  �=�= 0 xpos  � o  �<�< 0 windowdetails windowDetails�?  �>  � o  �;�; 0 windowoffset windowOffset� ��:� [  ��� l ��9�8� n  ��� o  �7�7 0 ypos  � o  �6�6 0 windowdetails windowDetails�9  �8  � o  �5�5 0 windowoffset windowOffset�:  � o      �4�4  0 windowposition windowPosition� ��� r  2��� J  .�� ��� n  %��� o  !%�3�3 0 x  � o  !�2�2 0 windowdetails windowDetails� ��1� n  %,��� o  (,�0�0 0 y  � o  %(�/�/ 0 windowdetails windowDetails�1  � o      �.�. 0 
windowsize 
windowSize� ��� r  3?��� o  36�-�-  0 windowposition windowPosition� n      ��� 1  :>�,
�, 
posn� 4  6:�+�
�+ 
cwin� o  89�*�* 0 w  � � � r  @L o  @C�)�) 0 
windowsize 
windowSize n       1  GK�(
�( 
ptsz 4  CG�'
�' 
cwin o  EF�&�& 0 w    �% r  MX \  MT	
	 o  MP�$�$ 0 windowoffset windowOffset
 o  PS�#�# "0 windowoffsetinc windowOffsetInc o      �"�" 0 windowoffset windowOffset�%  �C  �B  �E 0 w  � m  ���!�! � l ��� � I ����
� .corecnte****       **** 2 ���
� 
cwin�  �   �  �D  � � l bb����  �  �  �  � 4  ���
� 
pcap l ���� c  �� n  �� 1  ���
� 
pnam o  ���� 0 p   m  ���
� 
TEXT�  �  � m  ���                                                                                  sevs  alis    \  Macintosh HD                   BD ����System Events.app                                              ����            ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  �Y  �l  �k  �m  �u  �t  �v 0 p  � 2  il�
� 
prcs�  l ss����  �  �    l  ss��  ��
	repeat with p in every process		if background only of p is false then			set appName to name of p			-- log appName			-- log (appName is activeApp)						log appName						try				tell application "System Events" to tell application process (name of p as string)					set windowsCnt to count of windows					-- log windowsCnt										set windowSize to size of window 1					set windowPosition to position of window 1					set xDiff to (item 1 of windowSize) - (item 1 of windowPosition)					set yDiff to (item 2 of windowSize) - (item 2 of windowPosition)										-- log {"windowInfo", appName, windowSize, windowPosition, xDiff, yDiff}				end tell			on error line number num				-- display dialog "Error on line number " & num			end try		end if	end repeat		repeat with p in every process		try			if background only of p is false then				set appName to name of p				set windowDetails to (my getVal(myWindows, appName))								tell application "System Events" to tell application process (name of p as string)					set windowsCnt to count of windows										set windowOffsetInc to 30					set windowOffset to ((count of windows) - 1) * windowOffsetInc										repeat with w from 1 to (count of windows)												if windowDetails is not null then							set windowPosition to {(xpos of windowDetails) + windowOffset, (ypos of windowDetails) + windowOffset}							set windowSize to {x of windowDetails, y of windowDetails}							set position of window w to windowPosition							set size of window w to windowSize							set windowOffset to windowOffset - windowOffsetInc						end if					end repeat									end tell			end if		on error line number num			display dialog (get properties of p)		end try	end repeat
	    �� 
 	 r e p e a t   w i t h   p   i n   e v e r y   p r o c e s s  	 	 i f   b a c k g r o u n d   o n l y   o f   p   i s   f a l s e   t h e n  	 	 	 s e t   a p p N a m e   t o   n a m e   o f   p  	 	 	 - -   l o g   a p p N a m e  	 	 	 - -   l o g   ( a p p N a m e   i s   a c t i v e A p p )  	 	 	  	 	 	 l o g   a p p N a m e  	 	 	  	 	 	 t r y  	 	 	 	 t e l l   a p p l i c a t i o n   " S y s t e m   E v e n t s "   t o   t e l l   a p p l i c a t i o n   p r o c e s s   ( n a m e   o f   p   a s   s t r i n g )  	 	 	 	 	 s e t   w i n d o w s C n t   t o   c o u n t   o f   w i n d o w s  	 	 	 	 	 - -   l o g   w i n d o w s C n t  	 	 	 	 	  	 	 	 	 	 s e t   w i n d o w S i z e   t o   s i z e   o f   w i n d o w   1  	 	 	 	 	 s e t   w i n d o w P o s i t i o n   t o   p o s i t i o n   o f   w i n d o w   1  	 	 	 	 	 s e t   x D i f f   t o   ( i t e m   1   o f   w i n d o w S i z e )   -   ( i t e m   1   o f   w i n d o w P o s i t i o n )  	 	 	 	 	 s e t   y D i f f   t o   ( i t e m   2   o f   w i n d o w S i z e )   -   ( i t e m   2   o f   w i n d o w P o s i t i o n )  	 	 	 	 	  	 	 	 	 	 - -   l o g   { " w i n d o w I n f o " ,   a p p N a m e ,   w i n d o w S i z e ,   w i n d o w P o s i t i o n ,   x D i f f ,   y D i f f }  	 	 	 	 e n d   t e l l  	 	 	 o n   e r r o r   l i n e   n u m b e r   n u m  	 	 	 	 - -   d i s p l a y   d i a l o g   " E r r o r   o n   l i n e   n u m b e r   "   &   n u m  	 	 	 e n d   t r y  	 	 e n d   i f  	 e n d   r e p e a t  	  	 r e p e a t   w i t h   p   i n   e v e r y   p r o c e s s  	 	 t r y  	 	 	 i f   b a c k g r o u n d   o n l y   o f   p   i s   f a l s e   t h e n  	 	 	 	 s e t   a p p N a m e   t o   n a m e   o f   p  	 	 	 	 s e t   w i n d o w D e t a i l s   t o   ( m y   g e t V a l ( m y W i n d o w s ,   a p p N a m e ) )  	 	 	 	  	 	 	 	 t e l l   a p p l i c a t i o n   " S y s t e m   E v e n t s "   t o   t e l l   a p p l i c a t i o n   p r o c e s s   ( n a m e   o f   p   a s   s t r i n g )  	 	 	 	 	 s e t   w i n d o w s C n t   t o   c o u n t   o f   w i n d o w s  	 	 	 	 	  	 	 	 	 	 s e t   w i n d o w O f f s e t I n c   t o   3 0  	 	 	 	 	 s e t   w i n d o w O f f s e t   t o   ( ( c o u n t   o f   w i n d o w s )   -   1 )   *   w i n d o w O f f s e t I n c  	 	 	 	 	  	 	 	 	 	 r e p e a t   w i t h   w   f r o m   1   t o   ( c o u n t   o f   w i n d o w s )  	 	 	 	 	 	  	 	 	 	 	 	 i f   w i n d o w D e t a i l s   i s   n o t   n u l l   t h e n  	 	 	 	 	 	 	 s e t   w i n d o w P o s i t i o n   t o   { ( x p o s   o f   w i n d o w D e t a i l s )   +   w i n d o w O f f s e t ,   ( y p o s   o f   w i n d o w D e t a i l s )   +   w i n d o w O f f s e t }  	 	 	 	 	 	 	 s e t   w i n d o w S i z e   t o   { x   o f   w i n d o w D e t a i l s ,   y   o f   w i n d o w D e t a i l s }  	 	 	 	 	 	 	 s e t   p o s i t i o n   o f   w i n d o w   w   t o   w i n d o w P o s i t i o n  	 	 	 	 	 	 	 s e t   s i z e   o f   w i n d o w   w   t o   w i n d o w S i z e  	 	 	 	 	 	 	 s e t   w i n d o w O f f s e t   t o   w i n d o w O f f s e t   -   w i n d o w O f f s e t I n c  	 	 	 	 	 	 e n d   i f  	 	 	 	 	 e n d   r e p e a t  	 	 	 	 	  	 	 	 	 e n d   t e l l  	 	 	 e n d   i f  	 	 o n   e r r o r   l i n e   n u m b e r   n u m  	 	 	 d i s p l a y   d i a l o g   ( g e t   p r o p e r t i e s   o f   p )  	 	 e n d   t r y  	 e n d   r e p e a t 
 	 � l ss��
�	�  �
  �	  �   m  ���                                                                                  sevs  alis    \  Macintosh HD                   BD ����System Events.app                                              ����            ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��   � l vv����  �  �  �   R      � 
� .ascrerr ****      � **** m      �
� 
clin  �!�
� 
errn! o      � �  0 num  �   l ��"#��  " 3 - display dialog "Error on line number " & num   # �$$ Z   d i s p l a y   d i a l o g   " E r r o r   o n   l i n e   n u m b e r   "   &   n u m��  ��   %&% l     ��������  ��  ��  & '(' l      ��)*��  )
set response to display dialog "Which app windows to gather?" default answer "MacVim" with icon note buttons {"Continue", "Cancel"} default button "Continue"set targetAppName to (item 2 of (text of response))log targetAppNamelog (path to frontmost application as text)   * �++& 
 s e t   r e s p o n s e   t o   d i s p l a y   d i a l o g   " W h i c h   a p p   w i n d o w s   t o   g a t h e r ? "   d e f a u l t   a n s w e r   " M a c V i m "   w i t h   i c o n   n o t e   b u t t o n s   { " C o n t i n u e " ,   " C a n c e l " }   d e f a u l t   b u t t o n   " C o n t i n u e "   s e t   t a r g e t A p p N a m e   t o   ( i t e m   2   o f   ( t e x t   o f   r e s p o n s e ) )  l o g   t a r g e t A p p N a m e   l o g   ( p a t h   t o   f r o n t m o s t   a p p l i c a t i o n   a s   t e x t ) ( ,-, l �g.����. Q  �g/01/ k  �^22 343 l ����������  ��  ��  4 5��5 O  �^676 k  �]88 9:9 r  ��;<; 6��=>= 4 ����?
�� 
prcs? m  ������ > = ��@A@ n  ��BCB 1  ����
�� 
pisfC  g  ��A m  ����
�� boovtrue< o      ���� $0 frontmostprocess frontmostProcess: DED r  ��FGF m  ����
�� boovfalsG n      HIH 1  ����
�� 
pvisI o  ������ $0 frontmostprocess frontmostProcessE JKJ V  ��LML I ����N��
�� .sysodelanull��� ��� nmbrN m  ��OO ?ə�������  M l ��P����P = ��QRQ n  ��STS 1  ����
�� 
pisfT o  ������ $0 frontmostprocess frontmostProcessR m  ����
�� boovtrue��  ��  K UVU l ����������  ��  ��  V WXW l ����YZ��  Y Q K set activeApp to name of first application process whose frontmost is true   Z �[[ �   s e t   a c t i v e A p p   t o   n a m e   o f   f i r s t   a p p l i c a t i o n   p r o c e s s   w h o s e   f r o n t m o s t   i s   t r u eX \]\ r  ��^_^ 6��`a` n  ��bcb 1  ����
�� 
pnamc 4 ����d
�� 
prcsd m  ������ a = ��efe n  ��ghg 1  ����
�� 
pisfh  g  ��f m  ����
�� boovtrue_ o      ���� 0 	activeapp 	activeApp] iji l ����������  ��  ��  j klk l  ����mn��  m + %			set activeApp to "Google Chrome"   n �oo J 	  	 	 s e t   a c t i v e A p p   t o   " G o o g l e   C h r o m e " l pqp I ����r��
�� .ascrcmnt****      � ****r o  ������ 0 	activeapp 	activeApp��  q sts l ����������  ��  ��  t uvu l  ����wx��  w � �		set response to display dialog "Which app windows to gather?" default answer activeApp with icon note buttons {"Continue", "Cancel"} default button "Continue"	   x �yyF 	  	 s e t   r e s p o n s e   t o   d i s p l a y   d i a l o g   " W h i c h   a p p   w i n d o w s   t o   g a t h e r ? "   d e f a u l t   a n s w e r   a c t i v e A p p   w i t h   i c o n   n o t e   b u t t o n s   { " C o n t i n u e " ,   " C a n c e l " }   d e f a u l t   b u t t o n   " C o n t i n u e "  	v z{z l ����������  ��  ��  { |��| X  �]}��~} Z  �X����� = ����� n  ����� 1  ����
�� 
bkgo� o  ������ 0 p  � m  ����
�� boovfals� k  T�� ��� r  ��� n  ��� 1  ��
�� 
pnam� o  ���� 0 p  � o      ���� 0 appname appName� ��� l 		������  �   log appName   � ���    l o g   a p p N a m e� ��� l 		������  � !  log (appName is activeApp)   � ��� 6   l o g   ( a p p N a m e   i s   a c t i v e A p p )� ��� l 		��������  ��  ��  � ���� Z  	T������� l 	������ = 	��� o  	���� 0 appname appName� o  ���� 0 	activeapp 	activeApp��  ��  � k  P�� ��� I �����
�� .ascrcmnt****      � ****� o  ���� 0 appname appName��  � ��� l ��������  ��  ��  � ���� O P��� O  O��� k  *N�� ��� r  *5��� I *1�����
�� .corecnte****       ****� 2 *-��
�� 
cwin��  � o      ���� 0 
windowscnt 
windowsCnt� ��� I 6=�����
�� .ascrcmnt****      � ****� o  69���� 0 
windowscnt 
windowsCnt��  � ��� l >>��������  ��  ��  � ��� l  >>������  � M G Google Chrome windows don't seem to have the right size/position info    � ��� �   G o o g l e   C h r o m e   w i n d o w s   d o n ' t   s e e m   t o   h a v e   t h e   r i g h t   s i z e / p o s i t i o n   i n f o  � ��� Z  >������� l >E������ = >E��� o  >A���� 0 appname appName� m  AD�� ���  G o o g l e   C h r o m e��  ��  � k  H��� ��� r  HT��� J  HP�� ��� m  HK������ ���� m  KN�������  � o      ���� 0 
windowsize 
windowSize� ��� r  Ua��� J  U]�� ��� m  UX������ ���� m  X[��������  � o      ����  0 windowposition windowPosition� ��� r  bs��� \  bo��� l bh������ n  bh��� 4  eh���
�� 
cobj� m  fg���� � o  be���� 0 
windowsize 
windowSize��  ��  � l hn������ n  hn��� 4  kn���
�� 
cobj� m  lm���� � o  hk����  0 windowposition windowPosition��  ��  � o      ���� 0 xdiff xDiff� ��� r  t���� \  t���� l tz������ n  tz��� 4  wz���
�� 
cobj� m  xy���� � o  tw���� 0 
windowsize 
windowSize��  ��  � l z������� n  z���� 4  }����
�� 
cobj� m  ~���� � o  z}����  0 windowposition windowPosition��  ��  � o      ���� 0 ydiff yDiff� ���� l ����������  ��  ��  ��  ��  � k  ���� ��� r  ����� n  ����� 1  ���
� 
ptsz� 4  ���~�
�~ 
cwin� m  ���}�} � o      �|�| 0 
windowsize 
windowSize� ��� r  ����� n  ����� 1  ���{
�{ 
posn� 4  ���z�
�z 
cwin� m  ���y�y � o      �x�x  0 windowposition windowPosition�    r  �� \  �� l ���w�v n  �� 4  ���u	
�u 
cobj	 m  ���t�t  o  ���s�s 0 
windowsize 
windowSize�w  �v   l ��
�r�q
 n  �� 4  ���p
�p 
cobj m  ���o�o  o  ���n�n  0 windowposition windowPosition�r  �q   o      �m�m 0 xdiff xDiff  r  �� \  �� l ���l�k n  �� 4  ���j
�j 
cobj m  ���i�i  o  ���h�h 0 
windowsize 
windowSize�l  �k   l ���g�f n  �� 4  ���e
�e 
cobj m  ���d�d  o  ���c�c  0 windowposition windowPosition�g  �f   o      �b�b 0 ydiff yDiff �a l ���`�_�^�`  �_  �^  �a  �  l ���]�\�[�]  �\  �[     I ���Z!�Y
�Z .ascrcmnt****      � ****! J  ��"" #$# o  ���X�X 0 
windowsize 
windowSize$ %&% o  ���W�W  0 windowposition windowPosition& '(' o  ���V�V 0 xdiff xDiff( )�U) o  ���T�T 0 ydiff yDiff�U  �Y    *+* l ���S�R�Q�S  �R  �Q  + ,-, r  ��./. m  ���P�P / o      �O�O "0 windowoffsetinc windowOffsetInc- 010 r  ��232 ]  ��454 l ��6�N�M6 \  ��787 l ��9�L�K9 I ���J:�I
�J .corecnte****       ****: 2 ���H
�H 
cwin�I  �L  �K  8 m  ���G�G �N  �M  5 o  ���F�F "0 windowoffsetinc windowOffsetInc3 o      �E�E 0 windowoffset windowOffset1 ;<; l ���D�C�B�D  �C  �B  < =>= Y  �L?�A@A�@? k  GBB CDC r  !EFE J  GG HIH [  JKJ l L�?�>L n  MNM 4  
�=O
�= 
cobjO m  �<�< N o  
�;�;  0 windowposition windowPosition�?  �>  K l P�:�9P o  �8�8 0 windowoffset windowOffset�:  �9  I Q�7Q [  RSR l T�6�5T n  UVU 4  �4W
�4 
cobjW m  �3�3 V o  �2�2  0 windowposition windowPosition�6  �5  S l X�1�0X o  �/�/ 0 windowoffset windowOffset�1  �0  �7  F o      �.�. &0 newwindowposition newWindowPositionD YZY l ""�-[\�-  [ ; 5 log {newWindowSize, newWindowPosition, xDiff, yDiff}   \ �]] j   l o g   { n e w W i n d o w S i z e ,   n e w W i n d o w P o s i t i o n ,   x D i f f ,   y D i f f }Z ^_^ l ""�,�+�*�,  �+  �*  _ `a` r  ".bcb o  "%�)�) &0 newwindowposition newWindowPositionc n      ded 1  )-�(
�( 
posne 4  %)�'f
�' 
cwinf o  '(�&�& 0 w  a ghg r  /;iji o  /2�%�% 0 
windowsize 
windowSizej n      klk 1  6:�$
�$ 
ptszl 4  26�#m
�# 
cwinm o  45�"�" 0 w  h n�!n r  <Gopo \  <Cqrq o  <?� �  0 windowoffset windowOffsetr o  ?B�� "0 windowoffsetinc windowOffsetIncp o      �� 0 windowoffset windowOffset�!  �A 0 w  @ m  ���� A l �s��s I ��t�
� .corecnte****       ****t 2 ���
� 
cwin�  �  �  �@  > uvu l MM����  �  �  v w�w l MM����  �  �  �  � 4  '�x
� 
pcapx l !&y��y c  !&z{z n  !$|}| 1  "$�
� 
pnam} o  !"�� 0 p  { m  $%�
� 
TEXT�  �  � m  ~~�                                                                                  sevs  alis    \  Macintosh HD                   BD ����System Events.app                                              ����            ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  ��  ��  ��  ��  ��  ��  �� 0 p  ~ 2  ���

�
 
prcs��  7 m  ���                                                                                  sevs  alis    \  Macintosh HD                   BD ����System Events.app                                              ����            ����  
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  ��  0 R      �	��
�	 .ascrerr ****      � ****� m      �
� 
clin� ���
� 
errn� o      �� 0 num  �  1 l ff����  � 3 - display dialog "Error on line number " & num   � ��� Z   d i s p l a y   d i a l o g   " E r r o r   o n   l i n e   n u m b e r   "   &   n u m��  ��  - ��� l     ��� �  �  �   �       �����������  � �������������� &0 processestoignore processesToIgnore�� 0 getval getVal�� 0 getkeys getKeys�� 0 setwin setWin�� 0 getwin getWin
�� .aevtoappnull  �   � ****� ����� �   A E I M P� ������������ 0 getval getVal�� ����� �  ������ 0 thelist theList�� 0 thekey theKey��  � �������� 0 thelist theList�� 0 thekey theKey�� 0 theitem theItem� ����������
�� 
kocl
�� 
cobj
�� .corecnte****       ****
�� 
kMsg
�� 
null�� ) $�[��l kh ��,�  	�OY h[OY��O�� ��$���������� 0 getkeys getKeys�� ����� �  ���� 0 thelist theList��  � �������� 0 thelist theList�� 0 responselist responseList�� 0 theitem theItem� ��������7
�� 
kocl
�� 
cobj
�� .corecnte****       ****
�� 
kMsg�� 0jvE�O &�[��l kh ��,� ��,�6FY h[OY��O�� ��H���������� 0 setwin setWin�� ����� �  ������������ 0 win  �� 0 x  �� 0 y  �� 0 xpos  �� 0 ypos  ��  � ���������������� 0 win  �� 0 x  �� 0 y  �� 0 xpos  �� 0 ypos  ��  0 windowposition windowPosition�� 0 
windowsize 
windowSize� ������ 0 position  
�� 
ptsz�� ��lvE�O��lvE�O���,FO���,F� ��t���������� 0 getwin getWin�� ����� �  ������������ 0 win  �� 0 x  �� 0 y  �� 0 xpos  �� 0 ypos  ��  � ���������������� 0 win  �� 0 x  �� 0 y  �� 0 xpos  �� 0 ypos  ��  0 windowposition windowPosition�� 0 
windowsize 
windowSize�  �� ��lvE�O��lvE�O��lv� �����������
�� .aevtoappnull  �   � ****� k    g��  ^��  |�� ��� ��� �� �� ,����  ��  ��  � ������������ 0 i  �� 0 x  �� 0 p  �� 0 w  �� 0 num  � U y���������������� ������������������������������������������������������������������������������������~�}�|�{�z�y�xv�w�v�u�t�s�r�q�p�o���n�m�lO�k�j��i�h�g�f�e
�� 
desk
�� 
cwin
�� 
pbnd�� 0 _b  
�� 
cobj�� 0 screen_width  �� �� 0 screen_height  
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
ptsz�� 0 winsize winSize�� 0 _w  �� 0 _h  ��D��  ��  
�� 
kMsg�� 0 x  ��H�� 0 y  ���� 0 xpos  ����� 0 ypos  ��T�� 
���� b�����d����� R�� �� 0 	mywindows 	myWindows�� 0 getkeys getKeys�� 0 supportedapps supportedApps�� &0 showwindowdetails showWindowDetails
� 
kocl
�~ 
bkgo�} 0 appname appName�| 0 
windowscnt 
windowsCnt�{ 0 
windowsize 
windowSize�z  0 windowposition windowPosition�y 0 xdiff xDiff�x 0 ydiff yDiff�w 
�v .ascrcmnt****      � ****�u 0 getval getVal�t 0 windowdetails windowDetails�s �r "0 windowoffsetinc windowOffsetInc�q 0 windowoffset windowOffset
�p 
null
�o 
clin� �d�c�b
�d 
errn�c 0 num  �b  �  
�n 
pisf�m $0 frontmostprocess frontmostProcess
�l 
pvis
�k .sysodelanull��� ��� nmbr�j 0 	activeapp 	activeApp�i��h��g��f���e &0 newwindowposition newWindowPosition��h� *�,�,�,E�O��m/E�O���/E�UO� �*�-E�O �k�j kh  b   *��/�,�& � �*��/ � �k*�-j kh *�/a ,E` O_ �k/E` O_ �l/E` O*�/a ,E` O_ �k/E` O_ �l/E` O_ a  *_ _ _ a E` O_ _ lv*�/a ,FY h[OY��OPUW X  hY h[OY�@UOa a a a a a  a !a "a #a $a %a a &a a a a 'a !a "a #a (a %a a )a a a a 'a !a *a #a +a %a a ,a a a a 'a !a -a #a .a %a a /la 0vE` 1O)_ 1k+ 2E` 3OfE` 4O���_ 4 � �*�-[a 5�l kh �a 6,f  ���,E` 7O*�-j E` 8O� t*��,�&/ h*�-j E` 8O*�k/a ,E` 9O*�k/a ,E` :O_ 9�k/_ :�k/E` ;O_ 9�l/_ :�l/E` <Oa =_ 7_ 9_ :_ ;_ <a >vj ?OPUUY h[OY�aY hO*�-[a 5�l kh �a 6,f  ��,E` 7O_ 3_ 7 �*�-j E` 8O)_ 1_ 7l+ @E` AO� �*��,�&/ �*�-j E` 8Oa BE` CO*�-j k_ C E` DO yk*�-j kh _ Aa E \_ Aa !,_ D_ Aa #,_ DlvE` :O_ Aa ,_ Aa ,lvE` 9O_ :*�/a ,FO_ 9*�/a ,FO_ D_ CE` DY h[OY��OPUUY hY h[OY�OPUOPW X F GhO���*�k/a H[a I,\Ze81E` JOf_ Ja K,FO h_ Ja I,e a Lj M[OY��O*�k/�,a H[a I,\Ze81E` NO_ Nj ?Oy*�-[a 5�l kh �a 6,f X��,E` 7O_ 7_ N B_ 7j ?O�2*��,�&/&*�-j E` 8O_ 8j ?O_ 7a O  Da Pa QlvE` 9Oa Ra SlvE` :O_ 9�k/_ :�k/E` ;O_ 9�l/_ :�l/E` <OPY A*�k/a ,E` 9O*�k/a ,E` :O_ 9�k/_ :�k/E` ;O_ 9�l/_ :�l/E` <OPO_ 9_ :_ ;_ <�vj ?Oa BE` CO*�-j k_ C E` DO Tk*�-j kh _ :�k/_ D_ :�l/_ DlvE` TO_ T*�/a ,FO_ 9*�/a ,FO_ D_ CE` D[OY��OPUUY hY h[OY��UW X F Ghascr  ��ޭ