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
 cu             CoreServices  0/:System:Library:CoreServices:System Events.app/  $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  ��  ��   m  ��{ � l     �z�y�x�z  �y  �x  �{       �w � � ��w   � �v�u�v &0 processestoignore processesToIgnore
�u .aevtoappnull  �   � **** � �t ��t  �   @ � �s ��r�q � ��p
�s .aevtoappnull  �   � **** � k     � � �  N � �  l�o�o  �r  �q   � �n�m�n 0 i  �m 0 x   �  i�l�k�j�i�h�g�f�e ��d�c�b�a�`�_�^�]�\�[�Z�Y�X�W�V�U�T�S�R
�l 
desk
�k 
cwin
�j 
pbnd�i 0 _b  
�h 
cobj�g 0 screen_width  �f �e 0 screen_height  �d���c 0 min_xpos  
�b 
pcap�a 0 allprocesses allProcesses
�` .corecnte****       ****
�_ 
prcs
�^ 
pnam
�] 
TEXT
�\ 
posn�[ 0 winpos winPos�Z 0 _x  �Y 0 _y  
�X 
ptsz�W 0 winsize winSize�V 0 _w  �U 0 _h  �T��S  �R  �p �� *�,�,�,E�O��m/E�O���/E�UO� ��E�O*�-E�O �k�j kh  b   *�/a ,a & � �*�/ � k*�-j kh *�/a ,E` O_ �k/E` O_ �l/E` O*�/a ,E` O_ �k/E` O_ �l/E` O_ � a E` O_ _ lv*�/a ,FY h[OY��OPUW X  hY h[OY�JU ascr  ��ޭ