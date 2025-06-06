/* Copyright (C) 2013-2022 TU Dortmund
 * This file is part of AutomataLib, http://www.automatalib.net/.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package net.automatalib.automata.transducers.impl.compact;

import net.automatalib.automata.base.compact.CompactTransition;
import net.automatalib.automata.base.compact.UniversalCompactDet;
import net.automatalib.automata.transducers.MutableSubsequentialTransducer;
import net.automatalib.words.Alphabet;
import net.automatalib.words.Word;

public class CompactSST<I, O> extends UniversalCompactDet<I, Word<O>, Word<O>>
        implements MutableSubsequentialTransducer<Integer, I, CompactTransition<Word<O>>, O> {

    public CompactSST(Alphabet<I> alphabet) {
        super(alphabet);
    }

    public CompactSST(CompactSST<I, O> other) {
        super(other.getInputAlphabet(), other);
    }
}
