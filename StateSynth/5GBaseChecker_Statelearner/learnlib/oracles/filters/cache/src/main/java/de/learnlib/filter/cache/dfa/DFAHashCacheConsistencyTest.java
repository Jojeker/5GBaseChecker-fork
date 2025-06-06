/* Copyright (C) 2013-2022 TU Dortmund
 * This file is part of LearnLib, http://www.learnlib.de/.
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
package de.learnlib.filter.cache.dfa;

import java.util.Collection;
import java.util.Map;

import de.learnlib.api.oracle.EquivalenceOracle.DFAEquivalenceOracle;
import de.learnlib.api.query.DefaultQuery;
import net.automatalib.automata.fsa.DFA;
import net.automatalib.words.Word;
import org.checkerframework.checker.nullness.qual.Nullable;

final class DFAHashCacheConsistencyTest<I> implements DFAEquivalenceOracle<I> {

    private final Map<Word<I>, Boolean> cache;

    DFAHashCacheConsistencyTest(Map<Word<I>, Boolean> cache) {
        this.cache = cache;
    }

    @Override
    public @Nullable DefaultQuery<I, Boolean> findCounterExample(DFA<?, I> hypothesis, Collection<? extends I> inputs) {
        for (Map.Entry<Word<I>, Boolean> cacheEntry : cache.entrySet()) {
            Word<I> input = cacheEntry.getKey();
            Boolean answer = cacheEntry.getValue();

            if (!hypothesis.computeOutput(input).equals(answer)) {
                return new DefaultQuery<>(input, answer);
            }
        }
        return null;
    }

}
