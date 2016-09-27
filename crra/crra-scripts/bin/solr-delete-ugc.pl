#!/shared/perl/5.8.9/bin/perl

# solr-delete-ugc.pl - remove data from the index; dangerous!

# Eric Lease Morgan <emorgan@nd.edu>
# September 20, 2011 - switched from commit to optimize


# configure; no other editing should be necessary
use constant SOLR => 'http://localhost:8081/solr/biblio';

# require
use strict;
use WebService::Solr;

# initialize;
my $solr = WebService::Solr->new( SOLR );

# do the work
my $count = 0;
while ( <DATA> ) {

	$count++;
	chop;
	my $id = $_;
	print "item: $count; id = $id\n";
	$solr->delete_by_query( "id:$id" );

}

# done
print "Done.\n";
exit;

__DATA__
unaead_id2696678
unaead_id2704380
unaead_id2696012
unaead_id2696663
unaead_id2696143
unaead_id2703807
unaead_id2695989
unaead_id2687588
unaead_id2703909
unaead_id2696357
unaead_id2687698
unaead_id2696790
unaead_id2696583
unaead_id2696443
unaead_id2696488
unaead_id2703736
unaead_id2696005
unaead_id2687197
unaead_id2696712
unaead_id2687670
unaead_id2696002
unaead_id2687598
unaead_id2687349
unaead_id2687823
unaead_id2696630
unaead_id2696461
unaead_id2687205
unaead_id2696801
unaead_id2696555
unaead_id2687945
unaead_id2696568
unaead_id2696766
unaead_id2696020
unaead_id2703796
unaead_id2687188
unaead_id2696534
unaead_id2687304
unaead_id2687038
unaead_id2696136
unaead_id2696742
unaead_id2687931
unaead_id2687263
unaead_id2688197
unaead_id2687922
unaead_id2687311
unaead_id2696550
unaead_id2687170
unaead_id2687836
unaead_id2707657
unaead_id2696375
unaead_id2688182
unaead_id2687636
unaead_id2686984
unaead_id2687110
unaead_id2687177
unaead_id2696511
unaead_id2704468
unaead_id2696491
unaead_id2696409
unaead_id2688287
unaead_id2696123
unaead_id2696226
unaead_id2688203
unaead_id2696392
unaead_id2696177
unaead_id2687708
unaead_id2696695
unaead_id2696704
unaead_id2688257
unaead_id2696689
unaead_id2695526
unaead_id2696247
unaead_id2687070
unaead_id2696771
unaead_id2696598
unaead_id2696608
unaead_id2704456
unaead_id2696154
unaead_id2703936
unaead_id2698412
unaead_id2687558
unaead_id2687328
unaead_id2687337
unaead_id2696055
unaead_id2703705
unaead_id2687239
unaead_id2687249
unaead_id2704059
unaead_id2687021
unaead_id2687766
unaead_id2687775
unaead_id2704540
unaead_id2687051
unaead_id2704478
unaead_id2704488
unaead_id2696064
unaead_id2696073
unaead_id2704104
unaead_id2687680
unaead_id2687689
unaead_id2687728
unaead_id2687654
unaead_id2687663
unaead_id2745459
unaead_id2745468
unaead_id2704439
unaead_id2703717
unaead_id2703726
unaead_id2686998
unaead_id2687007
unaead_id2695337
unaead_id2695346
unaead_id2745075
unaead_id2745084
unaead_id2705215
unaead_id2696028
unaead_id2696038
unaead_id2687216
unaead_id2687225
unaead_id2692236
unaead_id2692245
unaead_id2695266
unaead_id2695275
unaead_id2697552
unaead_id2697562
unaead_id2687138
unaead_id2687147
unaead_id2687799
unaead_id2687808
unaead_id2704412
unaead_id2704421
unaead_id2745432
unaead_id2745442
unaead_id2745451
unaead_id2696818
unaead_id2696828
unaead_id2704119
unaead_id2704128
unaead_id2687745
unaead_id2687755
unaead_id2696419
unaead_id2696429
unaead_id2696438
unaead_id2687516
unaead_id2687525
unaead_id2691624
unaead_id2691634
unaead_id2687272
unaead_id2687282
unaead_id2687291
unaead_id2696263
unaead_id2696273
unaead_id2695246
unaead_id2695255
unaead_id2745132
unaead_id2745141
unaead_id2745150
unaead_id2704390
unaead_id2704400
unaead_id2687605
unaead_id2687615
unaead_id2687625
unaead_id2704068
unaead_id2704078
unaead_id2704087
unaead_id2745036
unaead_id2745045
unaead_id2745055
unaead_id2704500
unaead_id2704509
unaead_id2704519
unaead_id2697102
unaead_id2697111
unaead_id2697121
unaead_id2697131
unaead_id2696196
unaead_id2696205
unaead_id2696214
unaead_id2695206
unaead_id2695216
unaead_id2695226
unaead_id2695236
unaead_id2730157
unaead_id2730167
unaead_id2730176
unaead_id2689632
unaead_id2689641
unaead_id2689650
unaead_id2689660
unaead_id2689671
unaead_id2689680
unaead_id2689689
unaead_id2689699
unaead_id2687954
unaead_id2687963
unaead_id2687972
unaead_id2687982
unaead_id2692197
unaead_id2692206
unaead_id2692215
unaead_id2692225
unaead_id2695950
unaead_id2695959
unaead_id2695969
unaead_id2695978
unaead_id2695290
unaead_id2695299
unaead_id2695309
unaead_id2695319
unaead_id2695328
unaead_id2704015
unaead_id2704025
unaead_id2704035
unaead_id2704044
unaead_id2745091
unaead_id2745100
unaead_id2745109
unaead_id2745119
unaead_id2687362
unaead_id2687372
unaead_id2687382
unaead_id2687391
unaead_id2687400
unaead_id2704158
unaead_id2704167
unaead_id2704176
unaead_id2704186
unaead_id2704195
unaead_id2696297
unaead_id2696306
unaead_id2696316
unaead_id2696325
unaead_id2689774
unaead_id2689783
unaead_id2689793
unaead_id2689803
unaead_id2689812
unaead_id2689823
unaead_id2689832
unaead_id2689842
unaead_id2689851
unaead_id2689861
unaead_id2695812
unaead_id2695821
unaead_id2695831
unaead_id2695840
unaead_id2695850
unaead_id2750313
unaead_id2750322
unaead_id2750333
unaead_id2750343
unaead_id2750352
unaead_id2692483
unaead_id2692492
unaead_id2692502
unaead_id2692512
unaead_id2692522
unaead_id2692531
unaead_id2703744
unaead_id2703754
unaead_id2703764
unaead_id2703773
unaead_id2703783
unaead_id2703792
unaead_id2690992
unaead_id2691001
unaead_id2691010
unaead_id2691020
unaead_id2691029
unaead_id2691039
unaead_id2703645
unaead_id2703654
unaead_id2703664
unaead_id2703674
unaead_id2703683
unaead_id2703692
unaead_id2705434
unaead_id2705443
unaead_id2705452
unaead_id2705461
unaead_id2705471
unaead_id2705480
unaead_id2689708
unaead_id2689718
unaead_id2689728
unaead_id2689737
unaead_id2689747
unaead_id2689757
unaead_id2689766
unaead_id2691563
unaead_id2691573
unaead_id2691583
unaead_id2691593
unaead_id2691603
unaead_id2691612
unaead_id2703948
unaead_id2703958
unaead_id2703968
unaead_id2703977
unaead_id2703986
unaead_id2703996
unaead_id2704006
unaead_id2695541
unaead_id2695550
unaead_id2695560
unaead_id2695570
unaead_id2695579
unaead_id2695589
unaead_id2695598
unaead_id2689876
unaead_id2689886
unaead_id2689895
unaead_id2689904
unaead_id2689914
unaead_id2689924
unaead_id2689934
unaead_id2687847
unaead_id2687856
unaead_id2687866
unaead_id2687876
unaead_id2687885
unaead_id2687894
unaead_id2687905
unaead_id2687914
unaead_id2730082
unaead_id2730092
unaead_id2730101
unaead_id2730110
unaead_id2730120
unaead_id2730130
unaead_id2730140
unaead_id2694962
unaead_id2694972
unaead_id2694981
unaead_id2694991
unaead_id2695000
unaead_id2695010
unaead_id2695020
unaead_id2695030
unaead_id2687993
unaead_id2688003
unaead_id2688012
unaead_id2688022
unaead_id2688031
unaead_id2688041
unaead_id2688050
unaead_id2688060
unaead_id2688070
unaead_id2695868
unaead_id2695878
unaead_id2695887
unaead_id2695897
unaead_id2695906
unaead_id2695916
unaead_id2695925
unaead_id2695935
unaead_id2695944
unaead_id2688089
unaead_id2688098
unaead_id2688108
unaead_id2688117
unaead_id2688127
unaead_id2688137
unaead_id2688146
unaead_id2688156
unaead_id2688166
unaead_id2703813
unaead_id2703823
unaead_id2703832
unaead_id2703841
unaead_id2703851
unaead_id2703860
unaead_id2703870
unaead_id2703880
unaead_id2703889
unaead_id2703899
unaead_id2695711
unaead_id2695721
unaead_id2695731
unaead_id2695740
unaead_id2695750
unaead_id2695759
unaead_id2695769
unaead_id2695778
unaead_id2695788
unaead_id2695798
unaead_id2695607
unaead_id2695617
unaead_id2695626
unaead_id2695636
unaead_id2695645
unaead_id2695655
unaead_id2695665
unaead_id2695675
unaead_id2695684
unaead_id2695694
unaead_id2695703
unaead_id2691815
unaead_id2691825
unaead_id2691834
unaead_id2691844
unaead_id2691854
unaead_id2691864
unaead_id2691873
unaead_id2691883
unaead_id2691893
unaead_id2691902
unaead_id2691912
unaead_id2747334
unaead_id2747344
unaead_id2747354
unaead_id2747364
unaead_id2747373
unaead_id2747383
unaead_id2747393
unaead_id2747403
unaead_id2747412
unaead_id2747423
unaead_id2747435
unaead_id2747445
unaead_id2690669
unaead_id2690680
unaead_id2690691
unaead_id2690702
unaead_id2690713
unaead_id2690724
unaead_id2690734
unaead_id2690743
unaead_id2690752
unaead_id2690762
unaead_id2691044
unaead_id2691054
unaead_id2691063
unaead_id2691072
unaead_id2691082
unaead_id2691091
unaead_id2691102
unaead_id2691113
unaead_id2691125
unaead_id2691134
unaead_id2691144
unaead_id2691154
unaead_id2691163
unaead_id2702164
unaead_id2702173
unaead_id2702183
unaead_id2702192
unaead_id2702203
unaead_id2702213
unaead_id2702222
unaead_id2702232
unaead_id2702243
unaead_id2702252
unaead_id2702262
unaead_id2702272
unaead_id2702281
unaead_id2689508
unaead_id2689519
unaead_id2689528
unaead_id2689538
unaead_id2689548
unaead_id2689557
unaead_id2689567
unaead_id2689576
unaead_id2689585
unaead_id2689595
unaead_id2689604
unaead_id2689614
unaead_id2689624
unaead_id2745300
unaead_id2745310
unaead_id2745320
unaead_id2745330
unaead_id2745341
unaead_id2745351
unaead_id2745360
unaead_id2745370
unaead_id2745380
unaead_id2745389
unaead_id2745399
unaead_id2745409
unaead_id2745418
unaead_id2693807
unaead_id2693816
unaead_id2693826
unaead_id2693835
unaead_id2693844
unaead_id2693854
unaead_id2693863
unaead_id2693873
unaead_id2693884
unaead_id2693893
unaead_id2693902
unaead_id2693913
unaead_id2693923
unaead_id2693932
unaead_id2693942
unaead_id2693952
unaead_id2695047
unaead_id2695057
unaead_id2695066
unaead_id2695075
unaead_id2695086
unaead_id2695096
unaead_id2695106
unaead_id2695115
unaead_id2695124
unaead_id2695134
unaead_id2695143
unaead_id2695153
unaead_id2695162
unaead_id2695172
unaead_id2695182
unaead_id2695191
unaead_id2691644
unaead_id2691653
unaead_id2691662
unaead_id2691672
unaead_id2691681
unaead_id2691691
unaead_id2691701
unaead_id2691710
unaead_id2691720
unaead_id2691730
unaead_id2691740
unaead_id2691750
unaead_id2691760
unaead_id2691769
unaead_id2691779
unaead_id2691788
unaead_id2691798
unaead_id2691808
unaead_id2695357
unaead_id2695367
unaead_id2695376
unaead_id2695386
unaead_id2695397
unaead_id2695406
unaead_id2695416
unaead_id2695426
unaead_id2695436
unaead_id2695446
unaead_id2695456
unaead_id2695467
unaead_id2695477
unaead_id2695486
unaead_id2695496
unaead_id2695507
unaead_id2695517
unaead_id2704205
unaead_id2704214
unaead_id2704224
unaead_id2704235
unaead_id2704244
unaead_id2704254
unaead_id2704264
unaead_id2704273
unaead_id2704283
unaead_id2704292
unaead_id2704302
unaead_id2704311
unaead_id2704321
unaead_id2704331
unaead_id2704341
unaead_id2704350
unaead_id2704362
unaead_id2704372
unaead_id2700952
unaead_id2700961
unaead_id2700971
unaead_id2700980
unaead_id2700990
unaead_id2701000
unaead_id2701010
unaead_id2701019
unaead_id2701029
unaead_id2701039
unaead_id2701048
unaead_id2701058
unaead_id2701068
unaead_id2701077
unaead_id2701087
unaead_id2701098
unaead_id2701108
unaead_id2701117
unaead_id2694785
unaead_id2694796
unaead_id2694805
unaead_id2694816
unaead_id2694826
unaead_id2694836
unaead_id2694846
unaead_id2694855
unaead_id2694865
unaead_id2694874
unaead_id2694884
unaead_id2694895
unaead_id2694904
unaead_id2694913
unaead_id2694923
unaead_id2694933
unaead_id2694944
unaead_id2694954
unaead_id2744847
unaead_id2744857
unaead_id2744867
unaead_id2744876
unaead_id2744886
unaead_id2744896
unaead_id2744905
unaead_id2744914
unaead_id2744924
unaead_id2744933
unaead_id2744943
unaead_id2744952
unaead_id2744962
unaead_id2744971
unaead_id2744981
unaead_id2744990
unaead_id2745000
unaead_id2745009
unaead_id2745019
unaead_id2701131
unaead_id2701141
unaead_id2701150
unaead_id2701160
unaead_id2701169
unaead_id2701178
unaead_id2701188
unaead_id2701197
unaead_id2701207
unaead_id2701216
unaead_id2701226
unaead_id2701236
unaead_id2701245
unaead_id2701255
unaead_id2701264
unaead_id2701274
unaead_id2701283
unaead_id2701292
unaead_id2701302
unaead_id2701311
unaead_id2752555
unaead_id2752564
unaead_id2752574
unaead_id2752583
unaead_id2752593
unaead_id2752603
unaead_id2752613
unaead_id2752622
unaead_id2752632
unaead_id2752641
unaead_id2752651
unaead_id2752660
unaead_id2752670
unaead_id2752679
unaead_id2752689
unaead_id2752699
unaead_id2752708
unaead_id2752718
unaead_id2752727
unaead_id2752737
unaead_id2752746
unaead_id2756122
unaead_id2756132
unaead_id2756141
unaead_id2756151
unaead_id2756160
unaead_id2756170
unaead_id2756180
unaead_id2756189
unaead_id2756199
unaead_id2756208
unaead_id2756218
unaead_id2756228
unaead_id2756237
unaead_id2756247
unaead_id2756256
unaead_id2756266
unaead_id2756275
unaead_id2756285
unaead_id2756295
unaead_id2756304
unaead_id2705228
unaead_id2705237
unaead_id2705247
unaead_id2705256
unaead_id2705266
unaead_id2705276
unaead_id2705285
unaead_id2705295
unaead_id2705305
unaead_id2705314
unaead_id2705324
unaead_id2705334
unaead_id2705343
unaead_id2705353
unaead_id2705363
unaead_id2705372
unaead_id2705382
unaead_id2705391
unaead_id2705401
unaead_id2705410
unaead_id2705420
unaead_id2690774
unaead_id2690784
unaead_id2690793
unaead_id2690803
unaead_id2690813
unaead_id2690822
unaead_id2690832
unaead_id2690841
unaead_id2690850
unaead_id2690860
unaead_id2690869
unaead_id2690879
unaead_id2690888
unaead_id2690897
unaead_id2690907
unaead_id2690916
unaead_id2690926
unaead_id2690936
unaead_id2690945
unaead_id2690955
unaead_id2690964
unaead_id2690974
unaead_id2698188
unaead_id2698197
unaead_id2698207
unaead_id2698216
unaead_id2698226
unaead_id2698235
unaead_id2698245
unaead_id2698255
unaead_id2698264
unaead_id2698274
unaead_id2698283
unaead_id2698293
unaead_id2698302
unaead_id2698312
unaead_id2698321
unaead_id2698331
unaead_id2698340
unaead_id2698350
unaead_id2698359
unaead_id2698369
unaead_id2698378
unaead_id2698387
unaead_id2698397
unaead_id2692265
unaead_id2692274
unaead_id2692284
unaead_id2692293
unaead_id2692302
unaead_id2692311
unaead_id2692321
unaead_id2692330
unaead_id2692340
unaead_id2692349
unaead_id2692359
unaead_id2692368
unaead_id2692378
unaead_id2692387
unaead_id2692397
unaead_id2692406
unaead_id2692416
unaead_id2692425
unaead_id2692435
unaead_id2692445
unaead_id2692454
unaead_id2692464
unaead_id2692473
unaead_id2697950
unaead_id2697959
unaead_id2697969
unaead_id2697978
unaead_id2697988
unaead_id2697997
unaead_id2698007
unaead_id2698016
unaead_id2698026
unaead_id2698036
unaead_id2698045
unaead_id2698055
unaead_id2698064
unaead_id2698074
unaead_id2698083
unaead_id2698093
unaead_id2698102
unaead_id2698112
unaead_id2698121
unaead_id2698131
unaead_id2698140
unaead_id2698150
unaead_id2698159
unaead_id2698169
unaead_id2698178
unaead_id2692548
unaead_id2692557
unaead_id2692567
unaead_id2692576
unaead_id2692586
unaead_id2692596
unaead_id2692605
unaead_id2692615
unaead_id2692625
unaead_id2692634
unaead_id2692644
unaead_id2692653
unaead_id2692663
unaead_id2692672
unaead_id2692682
unaead_id2692691
unaead_id2692700
unaead_id2692710
unaead_id2692719
unaead_id2692730
unaead_id2692741
unaead_id2692752
unaead_id2692762
unaead_id2692772
unaead_id2692783
unaead_id2692793
unaead_id2692805
unaead_id2692814
unaead_id2692824
unaead_id2692835
unaead_id2692844
unaead_id2692856
unaead_id2692867
unaead_id2692876
unaead_id2692888
unaead_id2692898
unaead_id2692909
unaead_id2692920
unaead_id2692931
unaead_id2692942
unaead_id2692956
unaead_id2692969
unaead_id2692981
unaead_id2692994
unaead_id2693006
unaead_id2693018
unaead_id2693030
unaead_id2693042
unaead_id2693054
unaead_id2696834
unaead_id2696846
unaead_id2696858
unaead_id2696870
unaead_id2696882
unaead_id2696894
unaead_id2696906
unaead_id2696918
unaead_id2696931
unaead_id2696943
unaead_id2696955
unaead_id2696967
unaead_id2696979
unaead_id2696992
unaead_id2697004
unaead_id2697016
unaead_id2697028
unaead_id2697040
unaead_id2697052
unaead_id2697065
unaead_id2697077
unaead_id2697089
unaead_id2694412
unaead_id2694424
unaead_id2694436
unaead_id2694448
unaead_id2694461
unaead_id2694473
unaead_id2694485
unaead_id2694497
unaead_id2694509
unaead_id2694521
unaead_id2694534
unaead_id2694546
unaead_id2694558
unaead_id2694570
unaead_id2694582
unaead_id2694594
unaead_id2694606
unaead_id2694618
unaead_id2694631
unaead_id2694643
unaead_id2694655
unaead_id2694668
unaead_id2694680
unaead_id2694692
unaead_id2694704
unaead_id2694716
unaead_id2694729
unaead_id2694741
unaead_id2694753
unaead_id2694765
unaead_id2694777
unaead_id2697580
unaead_id2697592
unaead_id2697604
unaead_id2697616
unaead_id2697628
unaead_id2697640
unaead_id2697653
unaead_id2697665
unaead_id2697678
unaead_id2697690
unaead_id2697702
unaead_id2697715
unaead_id2697727
unaead_id2697740
unaead_id2697752
unaead_id2697764
unaead_id2697777
unaead_id2697789
unaead_id2697801
unaead_id2697813
unaead_id2697826
unaead_id2697838
unaead_id2697851
unaead_id2697863
unaead_id2697875
unaead_id2697888
unaead_id2697900
unaead_id2697912
unaead_id2697925
unaead_id2697937
unaead_id2691170
unaead_id2691182
unaead_id2691194
unaead_id2691207
unaead_id2691219
unaead_id2691231
unaead_id2691246
unaead_id2691262
unaead_id2691282
unaead_id2691301
unaead_id2691320
unaead_id2691338
unaead_id2691357
unaead_id2691376
unaead_id2691395
unaead_id2691414
unaead_id2691436
unaead_id2691458
unaead_id2691478
unaead_id2691497
unaead_id2691517
unaead_id2691536
unaead_id2702284
unaead_id2702303
unaead_id2702324
unaead_id2702343
unaead_id2702362
unaead_id2702382
unaead_id2702407
unaead_id2702427
unaead_id2702446
unaead_id2702466
unaead_id2702491
unaead_id2702511
unaead_id2702531
unaead_id2702554
unaead_id2702574
unaead_id2702594
unaead_id2702616
unaead_id2702636
unaead_id2702655
unaead_id2702679
unaead_id2745165
unaead_id2745185
unaead_id2745210
unaead_id2745230
unaead_id2745250
unaead_id2745269
unaead_id2697411
unaead_id2697431
unaead_id2697451
unaead_id2697472
unaead_id2697493
unaead_id2697513
unaead_id2697533
unaead_id2712537
unaead_id2712556
unaead_id2712576
unaead_id2712598
unaead_id2712619
unaead_id2712639
unaead_id2712658
unaead_id2712678
unaead_id2712699
unaead_id2712719
unaead_id2712738
unaead_id2712758
unaead_id2712778
unaead_id2712798
unaead_id2712818
unaead_id2712838
unaead_id2712862
unaead_id2712887
unaead_id2712912
unaead_id2712932
unaead_id2712951
unaead_id2712971
unaead_id2693965
unaead_id2693985
unaead_id2694006
unaead_id2694026
unaead_id2694047
unaead_id2694066
unaead_id2694086
unaead_id2694106
unaead_id2694125
unaead_id2694145
unaead_id2694165
unaead_id2694185
unaead_id2694205
unaead_id2694225
unaead_id2694244
unaead_id2694264
unaead_id2694284
unaead_id2694303
unaead_id2694322
unaead_id2694342
unaead_id2694362
unaead_id2694381
unaead_id2694401
unaead_id2746884
unaead_id2746903
unaead_id2746923
unaead_id2746942
unaead_id2746961
unaead_id2746980
unaead_id2747000
unaead_id2747020
unaead_id2747039
unaead_id2747059
unaead_id2747079
unaead_id2747098
unaead_id2747118
unaead_id2747137
unaead_id2747157
unaead_id2747176
unaead_id2747196
unaead_id2747216
unaead_id2747236
unaead_id2747257
unaead_id2747277
unaead_id2747297
unaead_id2747316
unaead_id2705547
unaead_id2705569
unaead_id2705589
unaead_id2705609
unaead_id2705629
unaead_id2705649
unaead_id2705669
unaead_id2705689
unaead_id2705710
unaead_id2705733
unaead_id2705754
unaead_id2705774
unaead_id2705794
unaead_id2705814
unaead_id2705832
unaead_id2705852
unaead_id2705872
unaead_id2705892
unaead_id2705913
unaead_id2705932
unaead_id2705952
unaead_id2705972
unaead_id2705993
unaead_id2706013
unaead_id2706034
unaead_id2704562
unaead_id2704581
unaead_id2704602
unaead_id2704622
unaead_id2704646
unaead_id2704667
unaead_id2704688
unaead_id2704708
unaead_id2704727
unaead_id2704745
unaead_id2704766
unaead_id2704786
unaead_id2704807
unaead_id2704827
unaead_id2704847
unaead_id2704868
unaead_id2704888
unaead_id2704908
unaead_id2704929
unaead_id2704950
unaead_id2704970
unaead_id2704990
unaead_id2705010
unaead_id2705030
unaead_id2705049
unaead_id2705069
unaead_id2705089
unaead_id2705109
unaead_id2705129
unaead_id2705152
unaead_id2705174
unaead_id2705194
unaead_id2689951
unaead_id2689970
unaead_id2689989
unaead_id2690009
unaead_id2690028
unaead_id2690049
unaead_id2690069
unaead_id2690088
unaead_id2690110
unaead_id2690131
unaead_id2690151
unaead_id2690172
unaead_id2690192
unaead_id2690213
unaead_id2690233
unaead_id2690254
unaead_id2690274
unaead_id2690293
unaead_id2690315
unaead_id2690335
unaead_id2690355
unaead_id2690375
unaead_id2690395
unaead_id2690416
unaead_id2690436
unaead_id2690456
unaead_id2690475
unaead_id2690495
unaead_id2690514
unaead_id2690534
unaead_id2690554
unaead_id2690574
unaead_id2690594
unaead_id2690615
unaead_id2690634
unaead_id2690655
unaead_id2693083
unaead_id2693103
unaead_id2693124
unaead_id2693144
unaead_id2693164
unaead_id2693184
unaead_id2693205
unaead_id2693225
unaead_id2693245
unaead_id2693265
unaead_id2693285
unaead_id2693305
unaead_id2693327
unaead_id2693347
unaead_id2693366
unaead_id2693386
unaead_id2693406
unaead_id2693427
unaead_id2693447
unaead_id2693466
unaead_id2693486
unaead_id2693506
unaead_id2693524
unaead_id2693544
unaead_id2693565
unaead_id2693585
unaead_id2693605
unaead_id2693626
unaead_id2693648
unaead_id2693667
unaead_id2693686
unaead_id2693705
unaead_id2693725
unaead_id2693744
unaead_id2693764
unaead_id2693784
unaead_id2693804
unaead_id2701335
unaead_id2701355
unaead_id2701375
unaead_id2701396
unaead_id2701415
unaead_id2701434
unaead_id2701454
unaead_id2701473
unaead_id2701492
unaead_id2701512
unaead_id2701531
unaead_id2701550
unaead_id2701569
unaead_id2701588
unaead_id2701608
unaead_id2701627
unaead_id2701646
unaead_id2701667
unaead_id2701684
unaead_id2701697
unaead_id2701709
unaead_id2701722
unaead_id2701734
unaead_id2701745
unaead_id2701758
unaead_id2701770
unaead_id2701783
unaead_id2701796
unaead_id2701808
unaead_id2701820
unaead_id2701833
unaead_id2701845
unaead_id2701858
unaead_id2701870
unaead_id2701883
unaead_id2701896
unaead_id2701908
unaead_id2701921
unaead_id2701934
unaead_id2701946
unaead_id2701958
unaead_id2701971
unaead_id2701983
unaead_id2701996
unaead_id2702008
unaead_id2702020
unaead_id2702033
unaead_id2702046
unaead_id2702058
unaead_id2702070
unaead_id2702083
unaead_id2702095
unaead_id2702107
unaead_id2702120
unaead_id2702132
unaead_id2702144
unaead_id2750365
unaead_id2750377
unaead_id2750389
unaead_id2750402
unaead_id2750414
unaead_id2750427
unaead_id2750439
unaead_id2750451
unaead_id2750464
unaead_id2750476
unaead_id2750489
unaead_id2750501
unaead_id2750514
unaead_id2750526
unaead_id2750538
unaead_id2750551
unaead_id2750563
unaead_id2750576
unaead_id2750588
unaead_id2750601
unaead_id2750613
unaead_id2750626
unaead_id2750639
unaead_id2750651
unaead_id2750664
unaead_id2750676
unaead_id2750689
unaead_id2750701
unaead_id2750714
unaead_id2750726
unaead_id2750738
unaead_id2750750
unaead_id2750763
unaead_id2750775
unaead_id2750787
unaead_id2750799
unaead_id2750811
unaead_id2750823
unaead_id2750836
unaead_id2750848
unaead_id2750860
unaead_id2750872
unaead_id2750884
unaead_id2750896
unaead_id2750908
unaead_id2750921
unaead_id2750933
unaead_id2750945
unaead_id2750957
unaead_id2750969
unaead_id2750982
unaead_id2750994
unaead_id2751006
unaead_id2751018
unaead_id2751030
unaead_id2751042
unaead_id2751054
unaead_id2751066
unaead_id2751079
unaead_id2751091
unaead_id2751103
unaead_id2751115
unaead_id2751127
unaead_id2751139
unaead_id2751151
unaead_id2751163
unaead_id2751176
unaead_id2751188
unaead_id2751200
unaead_id2751212
unaead_id2751224
unaead_id2751236
unaead_id2726178
unaead_id2726190
unaead_id2726202
unaead_id2726214
unaead_id2726226
unaead_id2726238
unaead_id2726250
unaead_id2726262
unaead_id2726275
unaead_id2726287
unaead_id2726299
unaead_id2726311
unaead_id2726323
unaead_id2726335
unaead_id2726348
unaead_id2726360
unaead_id2726372
unaead_id2726384
unaead_id2726396
unaead_id2726408
unaead_id2726420
unaead_id2726433
unaead_id2726445
unaead_id2726457
unaead_id2726469
unaead_id2726481
unaead_id2726493
unaead_id2726506
unaead_id2726518
unaead_id2726530
unaead_id2726542
unaead_id2726554
unaead_id2726566
unaead_id2726578
unaead_id2726590
unaead_id2726603
unaead_id2726615
unaead_id2726627
unaead_id2726639
unaead_id2726651
unaead_id2726664
unaead_id2726676
unaead_id2726688
unaead_id2726700
unaead_id2726713
unaead_id2726726
unaead_id2726738
unaead_id2726751
unaead_id2726764
unaead_id2726776
unaead_id2726789
unaead_id2726802
unaead_id2726815
unaead_id2726827
unaead_id2726840
unaead_id2726853
unaead_id2726866
unaead_id2726879
unaead_id2726891
unaead_id2726904
unaead_id2726917
unaead_id2726930
unaead_id2726942
unaead_id2726955
unaead_id2726967
unaead_id2726980
unaead_id2726992
unaead_id2727005
unaead_id2727017
unaead_id2727030
unaead_id2727042
unaead_id2727054
unaead_id2727067
unaead_id2727079
unaead_id2702692
unaead_id2702704
unaead_id2702716
unaead_id2702729
unaead_id2702741
unaead_id2702753
unaead_id2702766
unaead_id2702778
unaead_id2702790
unaead_id2702802
unaead_id2702814
unaead_id2702826
unaead_id2702839
unaead_id2702851
unaead_id2702863
unaead_id2702875
unaead_id2702888
unaead_id2702900
unaead_id2702912
unaead_id2702924
unaead_id2702937
unaead_id2702949
unaead_id2702961
unaead_id2702974
unaead_id2702986
unaead_id2702998
unaead_id2703010
unaead_id2703022
unaead_id2703034
unaead_id2703046
unaead_id2703058
unaead_id2703071
unaead_id2703083
unaead_id2703095
unaead_id2703108
unaead_id2703120
unaead_id2703132
unaead_id2703144
unaead_id2703157
unaead_id2703169
unaead_id2703181
unaead_id2703194
unaead_id2703206
unaead_id2703218
unaead_id2703230
unaead_id2703243
unaead_id2703255
unaead_id2703267
unaead_id2703280
unaead_id2703292
unaead_id2703304
unaead_id2703317
unaead_id2703329
unaead_id2703341
unaead_id2703353
unaead_id2703366
unaead_id2703378
unaead_id2703390
unaead_id2703403
unaead_id2703415
unaead_id2703427
unaead_id2703439
unaead_id2703452
unaead_id2703464
unaead_id2703476
unaead_id2703489
unaead_id2703501
unaead_id2703513
unaead_id2703526
unaead_id2703538
unaead_id2703550
unaead_id2703562
unaead_id2703575
unaead_id2703587
unaead_id2703599
unaead_id2703611
unaead_id2703624
unaead_id2688309
unaead_id2688321
unaead_id2688333
unaead_id2688345
unaead_id2688358
unaead_id2688370
unaead_id2688382
unaead_id2688394
unaead_id2688407
unaead_id2688419
unaead_id2688431
unaead_id2688443
unaead_id2688456
unaead_id2688468
unaead_id2688480
unaead_id2688493
unaead_id2688505
unaead_id2688517
unaead_id2688529
unaead_id2688542
unaead_id2688554
unaead_id2688566
unaead_id2688578
unaead_id2688590
unaead_id2688603
unaead_id2688615
unaead_id2688627
unaead_id2688639
unaead_id2688652
unaead_id2688664
unaead_id2688677
unaead_id2688689
unaead_id2688702
unaead_id2688714
unaead_id2688727
unaead_id2688739
unaead_id2688751
unaead_id2688766
unaead_id2688782
unaead_id2688794
unaead_id2688806
unaead_id2688818
unaead_id2688830
unaead_id2688842
unaead_id2688855
unaead_id2688867
unaead_id2688879
unaead_id2688892
unaead_id2688904
unaead_id2688917
unaead_id2688929
unaead_id2688941
unaead_id2688954
unaead_id2688966
unaead_id2688978
unaead_id2688990
unaead_id2689003
unaead_id2689015
unaead_id2689028
unaead_id2689040
unaead_id2689052
unaead_id2689064
unaead_id2689077
unaead_id2689089
unaead_id2689101
unaead_id2689114
unaead_id2689126
unaead_id2689138
unaead_id2689150
unaead_id2689163
unaead_id2689175
unaead_id2689187
unaead_id2689199
unaead_id2689211
unaead_id2689223
unaead_id2689235
unaead_id2689247
unaead_id2689259
unaead_id2689271
unaead_id2689283
unaead_id2689295
unaead_id2689307
unaead_id2689319
unaead_id2689331
unaead_id2689343
unaead_id2689355
unaead_id2689367
unaead_id2689379
unaead_id2689391
unaead_id2689403
unaead_id2689415
unaead_id2689427
unaead_id2689439
unaead_id2689451
unaead_id2689463
unaead_id2689475
unaead_id2689487
unaead_id2747448
unaead_id2747460
unaead_id2747472
unaead_id2747485
unaead_id2747497
unaead_id2747509
unaead_id2747521
unaead_id2747533
unaead_id2747545
unaead_id2747557
unaead_id2747569
unaead_id2747581
unaead_id2747593
unaead_id2747605
unaead_id2747617
unaead_id2747629
unaead_id2747641
unaead_id2747653
unaead_id2747665
unaead_id2747677
unaead_id2747689
unaead_id2747701
unaead_id2747713
unaead_id2747724
unaead_id2747737
unaead_id2747749
unaead_id2747761
unaead_id2747773
unaead_id2747785
unaead_id2747798
unaead_id2747810
unaead_id2747822
unaead_id2747834
unaead_id2747847
unaead_id2747859
unaead_id2747871
unaead_id2747883
unaead_id2747895
unaead_id2747907
unaead_id2747920
unaead_id2747932
unaead_id2747944
unaead_id2747956
unaead_id2747969
unaead_id2747981
unaead_id2747993
unaead_id2748006
unaead_id2748018
unaead_id2748030
unaead_id2748042
unaead_id2748055
unaead_id2748067
unaead_id2748079
unaead_id2748091
unaead_id2748104
unaead_id2748116
unaead_id2748128
unaead_id2748141
unaead_id2748153
unaead_id2748166